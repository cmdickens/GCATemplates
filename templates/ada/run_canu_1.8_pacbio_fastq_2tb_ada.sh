#BSUB -L /bin/bash              # use the bash login shell to initialize environment.
#BSUB -J canu_ada_westmere      # job name
#BSUB -n 40                     # assigns 40 cores for execution
#BSUB -R "span[ptile=40]"       # assigns 40 cores per node
#BSUB -R "select[mem2tb]"       # request 2TB memory node
#BSUB -R "rusage[mem=49750]"    # reserves 49GB memory per core
#BSUB -M 49750                  # sets to 49GB per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hour the job's runtime wall-clock limit.
#BSUB -q xlarge                 # xlarge queue required for Westmere nodes
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Westmere
module load Canu/1.8-intel-2017A-Python-3.5.2

<<'README'
    - Canu Tutorial: http://canu.readthedocs.io/en/latest/tutorial.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pacbio_raw_reads="/scratch/datasets/GCATemplates/data/pacbio/OR74A_filtered_subreads.fastq"

######## PARAMETERS ########
genome_size='40m'               # supported units: g, m, k
stop_on_low_coverage="stopOnLowCoverage=4"  # default 10, using 4 for sample dataset, adjust as needed

########## OUTPUTS #########
prefix="n_crassa"
assembly_directory="build_1.8_out"

################################### COMMANDS ###################################
# command to run pipeline with -pacbio-raw option
canu useGrid=false -p $prefix -d $assembly_directory genomeSize=$genome_size \
 -pacbio-raw $pacbio_raw_reads $stop_on_low_coverage 

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Canu: Koren S, Walenz BP, Berlin K, Miller JR, Phillippy AM.
            Canu: scalable and accurate long-read assembly via adaptive
            k-mer weighting and repeat separation. Genome Research. (2017).
CITATION
