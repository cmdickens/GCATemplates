#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=seqtk            # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=2         # tasks (commands) per compute node
#SBATCH --cpus-per-task=1           # CPUs (threads) per command
#SBATCH --mem=4G                    # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load seqtk/1.3-GCCcore-7.3.0

<<README
    - Seqtk manual: https://github.com/lh3/seqtk
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe1_1='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551981_pe_1.fastq.gz'
pe1_2='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551981_pe_2.fastq.gz'

######## PARAMETERS ########
sample_prefix='ERR551981'
subsample_fraction='0.1'        # 0.1 = keep 10%
random_seed=100                 # (remember to use the same random seed to keep pairing)

########## OUTPUTS #########

################################### COMMANDS ###################################

seqtk sample -s$random_seed $pe1_1 $subsample_fraction | gzip > ${sample_prefix}_1_${subsample_fraction}.fq.gz &
seqtk sample -s$random_seed $pe1_2 $subsample_fraction | gzip > ${sample_prefix}_2_${subsample_fraction}.fq.gz &
wait

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Seqtk: https://github.com/lh3/seqtk
CITATION
