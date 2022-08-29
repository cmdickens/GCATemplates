#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=seqtk            # job name
#SBATCH --time=01:00:00             # max job run time
#SBATCH --ntasks-per-node=2         # tasks (commands) per compute node
#SBATCH --cpus-per-task=2           # CPUs (threads) per command
#SBATCH --mem=32G                   # total memory
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/8.3.0 seqtk/1.3

<<README
    - Seqtk manual: https://github.com/lh3/seqtk
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe_1='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551981_pe_1.fastq.gz'
pe_2='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551981_pe_2.fastq.gz'

######## PARAMETERS ########
subsample_fraction='0.1'        # keep 10%
random_seed=100                 # (remember to use the same random seed to keep pairing)

########## OUTPUTS #########
pe_1_out="pe_1_subsample_${subsample_fraction}.fq"
pe_2_out="pe_2_subsample_${subsample_fraction}.fq"

################################### COMMANDS ###################################

seqtk sample -s$random_seed $pe_1 $subsample_fraction > $pe_1_out &
seqtk sample -s$random_seed $pe_2 $subsample_fraction > $pe_2_out &
wait

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Seqtk: https://github.com/lh3/seqtk
CITATION
