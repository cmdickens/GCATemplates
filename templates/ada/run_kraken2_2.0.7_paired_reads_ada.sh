#BSUB -L /bin/bash              # uses the bash login shell for the job's execution environment.
#BSUB -J karaken2               # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "select[mem256gb]"     # select 256GB memory compute node
#BSUB -R "rusage[mem=12300]"    # reserves 12300MB memory per core
#BSUB -M 12300                  # sets to 12300MB per process enforceable memory limit. (M * n)
#BSUB -W 96:00                  # sets to 96 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Kraken2/2.0.7-beta-intel-2018b-Perl-5.28.0

<<'README'
    - Kraken2 Manual: https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/DR34_R1.fastq.gz'
pe1_2='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/DR34_R2.fastq.gz'

######## PARAMETERS ########
export KRAKEN2_DEFAULT_DB='standard'    # RefSeq for bacterial, archaeal, viral, human and UniVec_Core domains
export KRAKEN2_DB_PATH='/scratch/datasets/kraken2/ada'
export KRAKEN2_NUM_THREADS=20

########## OUTPUTS #########
prefix='DR34'
kraken2_report="${prefix}_kraken2_report.tsv"
kraken2_out="${prefix}_kraken2_out.tsv"
class_out="${prefix}_kraken2_classified_out#.fq"
unclass_out="${prefix}_kraken2_unclassified_out#.fq"

################################### COMMANDS ###################################
#
kraken2 --report $kraken2_report --output $kraken2_out --classified-out $class_out \
  --unclassified-out $unclass_out --paired $pe1_1 $pe1_2

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Kraken:
        Wood DE, Salzberg SL: Kraken: ultrafast metagenomic sequence classification
        using exact alignments. Genome Biology 2014, 15:R46.
CITATION
