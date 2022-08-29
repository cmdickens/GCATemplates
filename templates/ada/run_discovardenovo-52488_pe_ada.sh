#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J discovar_de_novo       # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load discovar/discovardenovo-52488

<<README
    - DISCOVAR Manual: https://docs.google.com/document/d/1U_o-Z0dJ0QKiJn86AV2o_YHiFzUtW9c57eh3tYjkINc/edit?pli=1
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# reads are a comma separated list of files
reads="$SCRATCH/GCATemplates/data/sra/m_tuberculosis/ERR551611_pe_1_trimmo.fastq.gz,$SCRATCH/GCATemplates/data/sra/m_tuberculosis/ERR551611_pe_2_trimmo.fastq.gz"

######## PARAMETERS ########
threads=20                      # make sure this is <= your BSUB -n value

########## OUTPUTS #########
output_dir='./'

################################### COMMANDS ###################################
# command to run with defaults
DiscovarDeNovo NUM_THREADS=$threads READS=$reads OUT_DIR=$output_dir

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - DISCOVAR:
        Neil I Weisenfeld, Shuangye Yin, Ted Sharpe, Bayo Lau, Ryan Hegarty, Laurie Holmes, Brian Sogoloff, Diana Tabbaa,
        Louise Williams, Carsten Russ, Chad Nusbaum, Eric S Lander, Iain MacCallum & David B Jaffe.
        Comprehensive variation discovery in single human genomes. Nature Genetics 46, 1350–1355 (2014). doi:10.1038/ng.3121
CITATION

<<NOTE
    Sequencing data requirements summary:
        Illumina MiSeq or HiSeq 2500 genome sequencers
        PCR-free library preparation
        250 base paired end reads (or longer)
        ~450 base pair fragment size
        ~60x coverage

    DISCOVAR does not require a jumping library and cannot currently use one.
    Nor can it  use 100 base Illumina reads, or reads from other sequencing technologies at this time.
NOTE
