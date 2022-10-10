#!/bin/bash
#SBATCH --export=NONE                       # do not export current env to the job
#SBATCH --job-name=alphafold_multi-monomer  # job name
#SBATCH --time=1-00:00:00                   # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1                 # tasks (commands) per compute node
#SBATCH --cpus-per-task=24                  # CPUs (threads) per command
#SBATCH --mem=180G                          # total memory per node
#SBATCH --gres=gpu:a100:1                   # request one a100 GPU
#SBATCH --output=stdout.%x.%j               # save stdout to file
#SBATCH --error=stderr.%x.%j                # save stderr to file

module load GCC/10.2.0  CUDA/11.1.1  OpenMPI/4.0.5  AlphaFold/2.1.1

<<README
    - AlphaFold manual: https://github.com/deepmind/alphafold
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
protein_1_fasta=/scratch/data/bio/alphafold/example_data/T1083.fasta
protein_2_fasta=/scratch/data/bio/alphafold/example_data/T1084.fasta

######## PARAMETERS ########
DOWNLOAD_DIR=/scratch/data/bio/alphafold/2.1.0  # 3.4TB data already downloaded here
model_preset=monomer
max_template_date=2022-1-1
db_preset=full_dbs                  # full_dbs, reduced_dbs

########## OUTPUTS #########
output_dir=out_alphafold_2.1.1_multi-monomer

################################### COMMANDS ###################################
# start a process to monitor GPU usage
jobstats &

run_alphafold.py  \
 --data_dir=$DOWNLOAD_DIR  \
 --uniref90_database_path=$DOWNLOAD_DIR/uniref90/uniref90.fasta  \
 --mgnify_database_path=$DOWNLOAD_DIR/mgnify/mgy_clusters_2018_12.fa  \
 --bfd_database_path=$DOWNLOAD_DIR/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt  \
 --uniclust30_database_path=$DOWNLOAD_DIR/uniclust30/uniclust30_2021_03/UniRef30_2021_03 \
 --pdb70_database_path=$DOWNLOAD_DIR/pdb70/pdb70  \
 --template_mmcif_dir=$DOWNLOAD_DIR/pdb_mmcif/mmcif_files  \
 --obsolete_pdbs_path=$DOWNLOAD_DIR/pdb_mmcif/obsolete.dat \
 --model_preset=$model_preset \
 --max_template_date=$max_template_date \
 --db_preset=$db_preset \
 --output_dir=$output_dir \
 --fasta_paths=$protein_1_fasta,$protein_2_fasta

# create a graph of GPU resource usage stats
jobstats

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - AlphaFold:
        Jumper, John et al. "Highly accurate protein structure prediction with AlphaFold". Nature 596. 7873(2021): 583–589.
CITATIONS
