#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J sga_se_pe              # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SGA/0.10.13-intel-2015B
module load ABySS/1.9.0-intel-2015B-Python-2.7.10
module load SAMtools/1.2-intel-2015B-HTSlib-1.2.1
module load BWA/0.7.12-intel-2015B
module load pysam/0.8.3-intel-2015B-Python-2.7.10

<<README
    - SGA manual: https://github.com/jts/sga/tree/master/src#readme

    estimated run time: ~7 minutes; max memory ~1.2Gb
        genome size 4.4Mb
        210,924 300bp read pairs
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
threads=8                   # make sure this is <= your BSUB -n value
prefix='de_novo_sga_se_pe'
genome_size=4400000
num_pe_to_join_contigs=3    # number of paired read alignments required to join contigs into a scaffold

pe1_1='../../../data/sra/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe1_2='../../../data/sra/m_tuberculosis/ERR551611_pe_2.fastq.gz'

################################### COMMANDS ###################################
# command to run with defaults;
#   singletons are created during preprocessing paired end reads and are used in the assembly step
sga preprocess -q 20 -p 1 --out=${prefix}_pairs_pp.fastq --pe-orphans=${prefix}_sings_pp.fastq $pe1_1 $pe1_2

sga index -a ropebwt -t $threads --no-reverse ${prefix}_pairs_pp.fastq

sga index -a ropebwt -t $threads --no-reverse ${prefix}_sings_pp.fastq

sga correct -t $threads -o ${prefix}_pairs_pp_cor.fastq ${prefix}_pairs_pp.fastq

sga correct -t $threads -o ${prefix}_sings_pp_cor.fastq ${prefix}_sings_pp.fastq

cat ${prefix}_pairs_pp_cor.fastq ${prefix}_sings_pp_cor.fastq > ${prefix}_pairs_sings_pp_cor.fastq

sga index -a ropebwt -t $threads ${prefix}_pairs_sings_pp_cor.fastq

sga filter -t $threads -v --substring-only --no-kmer-check ${prefix}_pairs_sings_pp_cor.fastq

sga fm-merge -t $threads -m 65 ${prefix}_pairs_sings_pp_cor.filter.pass.fa

sga index -t $threads -a ropebwt ${prefix}_pairs_sings_pp_cor.filter.pass.merged.fa

sga overlap -t $threads -m 75 ${prefix}_pairs_sings_pp_cor.filter.pass.merged.fa

sga assemble -v ${prefix}_pairs_sings_pp_cor.filter.pass.merged.asqg.gz -o de_novo

#check to make sure the assembly completed before proceeding
if [[ ! -f de_novo-contigs.fa ]] ; then
    echo '======== no de_novo-contigs.fa file found.'
    echo '======== assembly failed see logs. aborting.'
    exit 1
fi

########################## scaffolding #########################################
#use bwa instead of sga-align
bwa index de_novo-contigs.fa
bwa aln -t $threads de_novo-contigs.fa $pe1_1 > pe1_1.aln.sai
bwa aln -t $threads de_novo-contigs.fa $pe1_2 > pe1_2.aln.sai
bwa sampe de_novo-contigs.fa pe1_1.aln.sai pe1_2.aln.sai $pe1_1 $pe1_2 | samtools view -Sb - > ${prefix}_pe.bam

sga-bam2de.pl -t $threads -n $num_pe_to_join_contigs -m 200 --prefix ${prefix}_pe ${prefix}_pe.bam
samtools sort ${prefix}_pe.bam ${prefix}_pe.refsort
sga-astat.py -m 200 ${prefix}_pe.refsort.bam > ${prefix}_pe.refsort.ctg.astat

sga scaffold -m 200 --pe ${prefix}_pe.de -a ${prefix}_pe.refsort.ctg.astat -o de_novo_sga_build.1pe.scaf de_novo-contigs.fa

sga scaffold2fasta -m 200 -a de_novo-graph.asqg.gz -o ${prefix}_de_novo_sga_build.scf.fasta de_novo_sga_build.1pe.scaf --write-unplaced --use-overlap

echo "FINISHED"

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SGA:
        Jared T. Simpson and Richard Durbin. Efficient de novo assembly of large genomes using compressed data structures.
        Genome Res. 2012 Mar; 22(3): 549–556. doi:  10.1101/gr.126953.111
CITATION
