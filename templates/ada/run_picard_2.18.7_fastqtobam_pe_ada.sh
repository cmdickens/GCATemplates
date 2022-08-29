#BSUB -L /bin/bash              # use the bash login shell for the job's execution environment.
#BSUB -J picard_fastqtobam      # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load picard/1.119-Java-1.7.0_80

<<README
    - This script creates an unaligned bam format file from fastq files
    - PICARD homepage: http://broadinstitute.github.io/picard
    - PICARD manual: http://broadinstitute.github.io/picard/command-line-overview.html#FastqToSam
            See the manual for adding read group information.
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1="/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_transcriptome_SRR958661_R1.fastq.gz"
pe1_2="/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_transcriptome_SRR958661_R2.fastq.gz"

######## PARAMETERS ########
prefix='SRR958661'
sort_order='coordinate'          # unsorted, queryname, coordinate, duplicate

########## OUTPUTS #########
# output.bam = bamfile format, output.sam = samfile format;
# if you would like a sam file, just change the outfile extension to .sam
outfile="${prefix}.bam"

################################### COMMANDS ###################################
# match the java max RAM with your BSUB max RAM. if BSUB max = 10GB then use java -Xmx10g
java -Xmx10g -jar $EBROOTPICARD/FastqToSam.jar FASTQ=$pe1_1 FASTQ2=$pe1_2 \
OUTPUT=$outfile SAMPLE_NAME=$sample_name SORT_ORDER=$sort_order \
MAX_RECORDS_IN_RAM='null' TMP_DIR=$TMPDIR

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - PICARD: http://broadinstitute.github.io/picard/
CITATION
