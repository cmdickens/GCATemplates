#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J fastqscreen            # job name
#BSUB -n 20                     # assigns 20 core for execution
#BSUB -R "span[ptile=20]"       # assigns 20 core per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load FastQScreen/0.12.1-GCCcore-6.3.0-Perl-5.24.0

<<README
    - FastQ Screen homepage: http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
se1_1='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/DR34_R1.fastq.gz'

######## PARAMETERS ########
threads=20                       # make sure this is <= your BSUB -n value
aligner='bwa'                   # bwa, bowtie, bowite2

########## OUTPUTS #########
out_directory="out_fastqscreen_${aligner}"

################################### COMMANDS ###################################
# full path to aligners now required; uncomment DBs below as needed
# make sure the --filter option matches the number of DATABASEs below
# if you have two DATABASE entries then the value for --filter must have 2 characters like --filter 00
echo "
BWA $EBROOTBWA/bin/bwa
BOWTIE $EBROOTBOWTIE/bin/bowtie
BOWTIE2 $EBROOTBOWTIE2/bin/bowtie2
BISMARK $EBROOTBISMARK/bismark

DATABASE univec  /scratch/datasets/genome_indexes/univec/UniVec_Core/$aligner/UniVec_Core.fa
DATABASE phix  /scratch/datasets/genome_indexes/ncbi/PhiX/$aligner/NC_001422.1
#DATABASE human  /scratch/datasets/genome_indexes/ucsc/hg19/$aligner/hg19.fa
" > dbs.conf

# you will need to edit (add/remove) some options in the command as needed
fastq_screen --quiet --conf dbs.conf --outdir $out_directory --threads $threads --tag --filter 00 --aligner $aligner $se1_1

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - FastQ Screen: http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/
CITATION
