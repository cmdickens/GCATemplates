#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=wtdbg2           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load wtdbg2/2.3-foss-2018b
module load BamTools/2.5.1-GCCcore-7.3.0
module load SAMtools/1.8-GCCcore-7.3.0
module load minimap2/2.17-GCCcore-7.3.0

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
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - wtdbg2: https://github.com/ruanjue/wtdbg2    
CITATION
