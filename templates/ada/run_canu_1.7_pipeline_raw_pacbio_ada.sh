#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J canu_pipeline          # job name
#BSUB -n 40                     # assigns 40 cores for execution
#BSUB -R "span[ptile=40]"       # assigns 40 cores per node
#BSUB -R "rusage[mem=24500]"    # reserves 24.5GB memory per core
#BSUB -M 24500                  # sets to 25.5GB per process enforceable memory limit. (M * n)
#BSUB -W 48:00                 # sets to 168 hour the job's runtime wall-clock limit.
#BSUB -q xlarge                 # xlarge queue required for Westmere nodes
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Westmere
module load Canu/1.7-intel-2017A-Perl-5.24.0

<<'README'
    - Canu Tutorial: http://canu.readthedocs.io/en/latest/tutorial.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pacbio_raw_reads="/scratch/datasets/GCATemplates/data/pacbio/OR74A_filtered_subreads.fastq"

######## PARAMETERS ########
assembly_directory="build_1.7_out"
genome_size='40m'               # supported units: g, m, k

########## OUTPUTS #########
prefix="n_crassa"

################################### COMMANDS ###################################
# command to run pipeline with -pacbio-raw option
canu useGrid=false -p $prefix -d $assembly_directory genomeSize=$genome_size -pacbio-raw $pacbio_raw_reads

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Canu: Koren S, Walenz BP, Berlin K, Miller JR, Phillippy AM.
            Canu: scalable and accurate long-read assembly via adaptive
            k-mer weighting and repeat separation. Genome Research. (2017).
CITATION
