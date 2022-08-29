#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J kraken_pe              # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=12300]"    # reserves 12300MB memory per core
#BSUB -M 12300                  # sets to 12300MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -R "select[mem256gb]"     # select 256GB node
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Kraken/1.1-GCCcore-6.3.0-Perl-5.24.0

<<README
    - Kraken manual: https://ccb.jhu.edu/software/kraken/MANUAL.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/DR34_R1.fastq.gz'
pe1_2='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/DR34_R2.fastq.gz'

######## PARAMETERS ########
export KRAKEN_DEFAULT_DB='bacteria'
export KRAKEN_DB_PATH='/scratch/datasets/kraken'
export KRAKEN_NUM_THREADS=20

########## OUTPUTS #########
out_prefix='out_pe'

################################### COMMANDS ###################################
# you only need to run --preload for the first command if you have multiple samples
kraken --preload --out-fmt paired --fastq-output --classified-out $out_prefix --fastq-input --paired --gzip-compressed $pe1_1 $pe1_2 --output kraken.out

# annotate classified hits
kraken-translate kraken.out > sequences.labels

# show report of percentage of hits to database entries
kraken-report kraken.out > report.out

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Kraken:
        Wood DE, Salzberg SL: Kraken: ultrafast metagenomic sequence classification
        using exact alignments. Genome Biology 2014, 15:R46.
CITATION
