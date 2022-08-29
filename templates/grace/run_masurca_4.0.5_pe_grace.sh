#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=masurca          # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/8.3.0  OpenMPI/3.1.4 MaSuRCA/4.0.5

<<README
    - MaSuRCA manual: http://spades.bioinf.spbau.ru/release3.5.0/manual.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
config_file='build_masurca_pe.conf'

pe1_1='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe1_2='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551611_pe_2.fastq.gz'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK
fragment_mean=400
fragment_stdev=20
jf_size=88000000            # JF_SIZE is 20 * genome_size

# see a detailed example config file here: ls $EBROOTMASURCA/masurca_config_example.txt
echo "DATA
PE= pe $fragment_mean $fragment_stdev $pe1_1 $pe1_2
END

PARAMETERS
GRAPH_KMER_SIZE=auto
USE_LINKING_MATES=1
LIMIT_JUMP_COVERAGE=60
NUM_THREADS=$threads
# for JF_SIZE, this is mandatory jellyfish hash size -- a safe value is estimated_genome_size*20
JF_SIZE=$jf_size
DO_HOMOPOLYMER_TRIM=0

#CABOG ASSEMBLY ONLY: set cgwErrorRate=0.25 for bacteria and 0.1<=cgwErrorRate<=0.15 for other organisms.
CA_PARAMETERS = ovlMerSize=30 cgwErrorRate=0.25 ovlHashBits=25 ovlHashBlockLength=180000000

END" > $config_file

########## OUTPUTS #########
# use masurca output defaults

################################### COMMANDS ###################################
# command to run with parameters specified in config file
masurca $config_file

./assemble.sh

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - MaSuRCA:
        Zimin, A. et al. The MaSuRCA genome Assembler. Bioinformatics (2013). doi:10.1093/bioinformatics/btt476 
CITATION
