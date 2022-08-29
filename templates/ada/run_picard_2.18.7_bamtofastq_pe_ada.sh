#BSUB -L /bin/bash              # use the bash login shell for the job's execution environment.
#BSUB -J bam_to_fastq           # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit.
#BSUB -W 24:00                  # sets to 24 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load picard/2.18.7-Java-1.8.0

<<README
    - PICARD homepage: http://broadinstitute.github.io/picard
    - PICARD manual: http://broadinstitute.github.io/picard/command-line-overview.html#FastqToSam
            See the manual for adding read group information.
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
input_bam='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/dr34_sorted.bam'

######## PARAMETERS ########
prefix='DR34'

########## OUTPUTS #########
r1_output_fastq="${prefix}_reads_R1.fastq"
r2_output_fastq="${prefix}_reads_R2.fastq"
unpaired_output_fastq="${prefix}_unpaired_reads.fastq"

################################### COMMANDS ###################################
#
java -jar $EBROOTPICARD/picard.jar SamToFastq I=$input_bam \
FASTQ=$r1_output_fastq SECOND_END_FASTQ=$r2_output_fastq UNPAIRED_FASTQ=$unpaired_output_fastq

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - PICARD: http://broadinstitute.github.io/picard/
CITATION
