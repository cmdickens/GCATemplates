#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J fastq-dump             # job name
#BSUB -n 2                      # assigns 1 cores for execution
#BSUB -R "span[ptile=2]"        # assigns 1 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SRA-Toolkit/2.9.1-1-centos_linux64

<<README
    - NOTICE: The compute nodes do not have internet access. Run this script on a login node
                only on pre-downloaded files because fastq-dump may take longer than 1 hour.

    - SRA-Toolkit:  The NCBI SRA Toolkit enables reading ("dumping") of sequencing files
                    from the SRA database and writing ("loading") files into the .sra format

    - SRA-Toolkit manual: http://www.ncbi.nlm.nih.gov/Traces/sra/?view=toolkit_doc
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# You must download the .sra file before processing since compute nodes do not have web access
sra_file='SRR575500.sra'

################################### COMMANDS ###################################
# use --split-files to split .sra file into two paired end files if .sra file is paired end

# Local file split, Library layout: PAIRED END
#fastq-dump -F -I --split-files --gzip $sra_file

# Library layout: SINGLE
fastq-dump -F -I --gzip $sra_file

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SRA-Toolkit:
        The NCBI Sequence Read Archive (SRA, http://www.ncbi.nlm.nih.gov/Traces/sra).
CITATION
