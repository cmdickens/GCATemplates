#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J sga_pe_mp              # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SGA/0.10.13-intel-2015B-Python-2.7.10
module load ABySS/1.9.0-intel-2015B-Python-2.7.10
module load SAMtools/1.2-intel-2015B-HTSlib-1.2.1
module load BWA/0.7.12-intel-2015B
module load pysam/0.8.3-intel-2015B-Python-2.7.10

<<README
    - SGA manual: https://github.com/jts/sga/tree/master/src#readme

    estimated run time: ~35 minutes; max memory ~2Gb
        genome size 4.4Mb
        210,924 300bp read pairs
        317,161 150bp mate pairs
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='../../../data/sra/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe1_2='../../../data/sra/m_tuberculosis/ERR551611_pe_2.fastq.gz'

mp1_1='../../../data/sra/m_tuberculosis/ERR760550_mp2kb_1_trimn.fastq.gz'
mp1_2='../../../data/sra/m_tuberculosis/ERR760550_mp2kb_2_trimn.fastq.gz'

######## PARAMETERS ########
threads=8                   # make sure this is <= your BSUB -n value
genome_size=4400000
num_pe_to_join_contigs=3    #number of pe alignments required to join contigs into a scaffold
num_mp_to_join_contigs=3    #number of mp alignments required to join contigs into a scaffold

########## OUTPUTS #########
prefix='de_novo_sga_pe_mp'

################################### COMMANDS ###################################
# command to run with defaults; singletons created after preprocess step are not used in the assembly
#   if you want to use singletons from preprocess step, use a different template
sga preprocess -q 20 -p 1 --out=${prefix}_pairs_pp.fastq --pe-orphans=${prefix}_sings_pp.fastq $pe1_1 $pe1_2

sga index -a ropebwt -t $threads --no-reverse ${prefix}_pairs_pp.fastq

sga correct -t $threads -k 51 --learn -o ${prefix}_pairs_pp_cor.fastq ${prefix}_pairs_pp.fastq

sga index -a ropebwt -t $threads ${prefix}_pairs_pp_cor.fastq

sga filter -t $threads -v --substring-only --no-kmer-check ${prefix}_pairs_pp_cor.fastq

sga fm-merge -t $threads -m 65 ${prefix}_pairs_pp_cor.filter.pass.fa

sga index -t $threads -a ropebwt ${prefix}_pairs_pp_cor.filter.pass.merged.fa

sga overlap -t $threads -m 75 ${prefix}_pairs_pp_cor.filter.pass.merged.fa

sga assemble -v ${prefix}_pairs_pp_cor.filter.pass.merged.asqg.gz -o de_novo -l 250

#check to make sure the assembly completed before proceeding
if [[ ! -f de_novo-contigs.fa ]] ; then
    echo '======== no de_novo-contigs.fa file found.'
    echo '======== assembly failed see logs. aborting.'
    exit 1
fi

########################## scaffolding #########################################
#use bwa instead of sga-align to align pe reads
bwa index de_novo-contigs.fa
bwa aln -t $threads de_novo-contigs.fa $pe1_1 > pe1_1.aln.sai
bwa aln -t $threads de_novo-contigs.fa $pe1_2 > pe1_2.aln.sai
bwa sampe de_novo-contigs.fa pe1_1.aln.sai pe1_2.aln.sai $pe1_1 $pe1_2 | samtools view -Sb - > ${prefix}_pe.bam

sga-bam2de.pl -t $threads -n $num_pe_to_join_contigs -m 200 --prefix ${prefix}_pe ${prefix}_pe.bam
samtools sort ${prefix}_pe.bam ${prefix}_pe_refsort
sga-astat.py -m 200 ${prefix}_pe_refsort.bam > ${prefix}_pe_refsort_ctg.astat

########################## scaffolding #########################################
#use bwa instead of sga-align to align mp reads
bwa aln -t $threads de_novo-contigs.fa $mp1_1 > mp1_1.aln.sai
bwa aln -t $threads de_novo-contigs.fa $mp1_2 > mp1_2.aln.sai
bwa sampe de_novo-contigs.fa mp1_1.aln.sai mp1_2.aln.sai $mp1_1 $mp1_2 | samtools view -Sb - > ${prefix}_mp2kb.bam

sga-bam2de.pl -t $threads -n $num_mp_to_join_contigs -m 200 --prefix ${prefix}_mp2kb ${prefix}_mp2kb.bam
samtools sort ${prefix}_mp2kb.bam ${prefix}_mp2kb_refsort
sga-astat.py -m 200 ${prefix}_mp2kb_refsort.bam > ${prefix}_mp2kb_refsort_ctg.astat

# use the astat file from highest coverage library (usually the pe library)
sga scaffold -m 200 --pe ${prefix}_pe.de --mate-pair ${prefix}_mp2kb.de -a ${prefix}_pe_refsort_ctg.astat -o de_novo_sga_build_pe_mp2kb.scaf de_novo-contigs.fa

sga scaffold2fasta -m 200 -f de_novo-contigs.fa -o ${prefix}_scaffolds.fasta de_novo_sga_build_pe_mp2kb.scaf --write-unplaced --use-overlap

echo "FINISHED"

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SGA:
        Jared T. Simpson and Richard Durbin. Efficient de novo assembly of large genomes using compressed data structures.
        Genome Res. 2012 Mar; 22(3): 549–556. doi:  10.1101/gr.126953.111
CITATION
