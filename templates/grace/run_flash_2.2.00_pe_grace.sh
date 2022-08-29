#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=flash2           # job name
#SBATCH --time=01:00:00             # max job run time
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=8           # CPUs (threads) per command
#SBATCH --mem=60G                   # total memory
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/7.3.0-2.30 OpenMPI/3.1.1 FLASH/2.2.00

<<README
    - FLASH homepage: https://github.com/dstreett/FLASH2
    - FLASH (Fast Length Adjustment of SHort reads) is an accurate and fast tool to merge
        paired-end reads that were generated from DNA fragments whose
        lengths are shorter than twice the length of reads.
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe_1='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe_2='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551611_pe_2.fastq.gz'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK
min_overlap=10                  # default 10
max_overlap=65                  # default 65

avg_read_length=250             # default 100
avg_frag_length=400             # default 180
stdev_frag_length=50            # default 20

########## OUTPUTS #########
output_prefix='ERR551611'

################################### COMMANDS ###################################
# command with gzip output (-z)
flash2 -z -m $min_overlap --threads $threads -r $avg_read_length -f $avg_frag_length -s $stdev_frag_length -o $output_prefix $pe_1 $pe_2

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - FLASH:
        FLASH: Fast length adjustment of short reads to improve genome assemblies. T. Magoc and S. Salzberg.
        Bioinformatics 27:21 (2011), 2957-63.
CITATION
