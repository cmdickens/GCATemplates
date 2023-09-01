#!/bin/bash
#SBATCH --job-name=iaf2
#SBATCH --time=1-00:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=480G
#SBATCH --output=stdout.%x.%j
#SBATCH --error=stderr.%x.%j

module load iaf2/.2.0.9
source activate /sw/hprc/sw/Anaconda3/2022.10/envs/iaf2-2.9.0

<<README
    - AlphaFold manual: https://github.com/deepmind/alphafold
README

######### SYNOPSIS #########
# this script will run Intel's CPU-only Optimized version of AlphaFold; no GPUs required

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
input_fasta_file='/scratch/data/bio/alphafold/example_data/1L2Y.fasta'

######## PARAMETERS ########
model="model_1"		# model_1, model_2, (not implemented yet: model_3, model_4, model_5)

########## OUTPUTS #########
output_dir="out_dir_T1083_${model}_jobid-${SLURM_JOBID}"

################################### COMMANDS ###################################
jobstats &

iaf2 -f $input_fasta_file -o $output_dir -m $model

jobstats

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - AlphaFold:
        Jumper, John et al. "Highly accurate protein structure prediction with AlphaFold". Nature 596. 7873(2021): 583–589.

        Tunyasuvunakool, Kathryn et al. "Highly accurate protein structure prediction for the human proteome". Nature 596. 7873(2021): 590–596.

CITATIONS
