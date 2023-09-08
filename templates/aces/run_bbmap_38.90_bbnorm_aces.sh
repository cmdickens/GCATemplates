#!/bin/bash
#SBATCH --job-name=bbnorm           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=96          # CPUs (threads) per command
#SBATCH --mem=480G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module purge
module load GCC/10.2.0 BBMap/38.90

<<README
    - BBNorm manual: https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbnorm-guide
README

######### SYNOPSIS #########
# will first error correct and then normalize fastq files to a targeted coverage

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe1_1='/scratch/data/bio/GCATemplates/data/hiseq/c_glabrata/SRR15498479_1.fastq.gz'
pe1_2='/scratch/data/bio/GCATemplates/data/hiseq/c_glabrata/SRR15498479_2.fastq.gz'

######## PARAMETERS ########
correction_kmer=63
target_coverage=75
min_coverage=5
max_memory=300

########## OUTPUTS #########
output_norm_file1='pe1_1_norm.fastq'
output_norm_file2='pe1_2_norm.fastq'
histogram_outfile='norm_hist.txt'

################################### COMMANDS ###################################
# run jobstats in the background (&) to monitor cpu usage in order to create a graph when the job completes
jobstats &

# error correct with tadpole first
tadpole.sh in=$pe1_1 in2=$pe1_2 out=pe1_1_ecc.fastq.gz out2=pe1_2_ecc.fastq.gz mode=correct k=$correction_kmer threads=$SLURM_CPUS_PER_TASK

# normalize to 50x on corrected reads
bbnorm.sh in=pe1_1_ecc.fastq.gz in2=pe1_2_ecc.fastq.gz out=$output_norm_file1 out2=$output_norm_file2 hist=$histogram_outfile tmpdir=$TMPDIR target=$target_coverage min=$min_coverage threads=$SLURM_CPUS_PER_TASK

# run jobstats to create a graph of cpu usage for this job  
jobstats

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BBMap:
        https://sourceforge.net/projects/bbmap
CITATIONS
