#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J metassembler           # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

#module load Westmere           #if using BSUB -q xlarge
module load Metassembler/1.5-intel-2015B-Python-2.7.10 MUMmer/3.23-intel-2015B

<<README
    Metassembler manual: http://sourceforge.net/projects/metassembler/files/?source=navbar
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
config_file="params.conf"

#you must specify the absolute path
build_1='/full/path/to/file/contigs_k91.fasta'
build_2='/full/path/to/file/test_sspace.final.scaffolds.fasta'

#you must specify the absolute path
pe_1='/full/path/to/file/ERR551611_pe_1.fastq.gz'
pe_2='/full/path/to/file/ERR551611_pe_2.fastq.gz'

#you must specify the absolute path; FR 2kb mate pairs
mp2kb_1='/full/path/to/file/ERR760550_mp2kb_1.fastq.gz'
mp2kb_2='/full/path/to/file/ERR760550_mp2kb_2.fastq.gz'

######## PARAMETERS ########
threads=8                       # make sure this is <= your BSUB -n value

# TODO Edit these parameters as needed according to your data set
echo "[global]
mateAn_A=200
mateAn_B=3000
bowtie2_threads=$threads
meta2fasta_keepUnaligned=1
meta2fasta_sizeUnaligned=500 500
nucmer_l=50
nucmer_c=300
genomeLength=4400000
nucmer=$EBROOTMUMMER/bin/nucmer

[1]
fasta=$build_2
ID=ecoli_pe_mp_assembly
bowtie2_read1=$mp2kb_1
bowtie2_read2=$mp2kb_2
bowtie2_maxins=5000
bowtie2_minins=1000

[2]
fasta=$build_1
ID=ecoli_pe_assembly
bowtie2_read1=$pe_1
bowtie2_read2=$pe_2
bowtie2_maxins=500
bowtie2_minins=100
" > $config_file

########## OUTPUTS #########
outdir='out_metassembler_pe_mp'

################################### COMMANDS ###################################
# command to run with defaults
metassemble --conf $config_file --outd $outdir

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Metassembler:
        Metassembler: Merging and optimizing de novo genome assemblies
        Wences, AH. Schatz, MC (2015) bioRxiv doi: http://dx.doi.org/10.1101/016352 
CITATION
