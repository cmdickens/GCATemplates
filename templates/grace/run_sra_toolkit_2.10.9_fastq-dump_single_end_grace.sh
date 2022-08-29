#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=fastq-dump       # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=1           # CPUs (threads) per command
#SBATCH --mem=7G                    # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/10.2.0  OpenMPI/4.0.5  SRA-Toolkit/2.10.9
module load WebProxy

<<README
    - SRA-Toolkit:  The NCBI SRA Toolkit enables reading ("dumping") of sequencing files
                    from the SRA database and writing ("loading") files into the .sra format

    - SRA-Toolkit manual: http://www.ncbi.nlm.nih.gov/Traces/sra/?view=toolkit_doc
README

<<FIRST_TIME_SETUP
    # run the following command to set up your download repository directory prior to running job scripts
    # set it to a directory in your $SCRATCH directory in order to not reach your home disk quota
vdb-config --interactive

    # use letter and tab keys or mouse click to select menu items
c for CACHE
o for choose
click [ Create Dir ] then hit enter and type /scratch/user/your_netid/ncbi
then select OK and hit enter and hit y to select yes for the question to change the location
then click s to save and x to exit

    # when you are done downloading sra files, you will need to remove downloaded .sra files
    #   from the directory $SCRATCH/ncbi/sra/
FIRST_TIME_SETUP

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
sra_accession_number='SRR5229945'

########## OUTPUTS ##########
# use default outputs

################################### COMMANDS ###################################
# add --split-files if library is paired end
fastq-dump -F -I --gzip $sra_accession_number

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SRA-Toolkit:
        The NCBI Sequence Read Archive (SRA, http://www.ncbi.nlm.nih.gov/Traces/sra).
CITATION
