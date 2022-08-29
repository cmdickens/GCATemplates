#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=wtdbg2           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/9.3.0 wtdbg2/2.5
module load BamTools/2.5.1
module load SAMtools/1.10
module load minimap2/2.17

<<README
    - wtdbg2 Manual: https://github.com/ruanjue/wtdbg2
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
subreads_fasta='/scratch/data/bio/GCATemplates/pacbio/arabidopsis_thaliana/a_thaliana_merged2subreads.fa.gz'

######## PARAMETERS ########
cpus=$SLURM_CPUS_PER_TASK
seq_type='sq'                   # sq (sequel), ont, ccs, rs
genome_size='135m'

########## OUTPUTS #########
out_prefix='a_thaliana'

################################### COMMANDS ###################################
# assemble long reads
wtdbg2 -t $cpus -g $genome_size -i $subreads_fasta -x $seq_type -o $out_prefix

# derive consensus
wtpoa-cns -t $cpus -i ${out_prefix}.ctg.lay.gz -o ${out_prefix}.ctg.fa

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - wtdbg2: https://github.com/ruanjue/wtdbg2    
CITATIONS
