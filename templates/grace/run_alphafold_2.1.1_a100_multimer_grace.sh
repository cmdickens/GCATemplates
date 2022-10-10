#!/bin/bash
#SBATCH --export=NONE                   # do not export current env to the job
#SBATCH --job-name=alphafold_multimer   # job name
#SBATCH --time=1-00:00:00               # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1             # tasks (commands) per compute node
#SBATCH --cpus-per-task=24              # CPUs (threads) per command
#SBATCH --mem=180G                      # total memory per node
#SBATCH --gres=gpu:a100:1               # request one a100 GPU
#SBATCH --output=stdout.%x.%j           # save stdout to file
#SBATCH --error=stderr.%x.%j            # save stderr to file

module load GCC/10.2.0  CUDA/11.1.1  OpenMPI/4.0.5  AlphaFold/2.1.1

<<README
    - AlphaFold manual: https://github.com/deepmind/alphafold
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
protein_fasta=/scratch/data/bio/alphafold/2.2.0/example_data/T1083_T1084_multimer.fasta

######## PARAMETERS ########
DOWNLOAD_DIR=/scratch/data/bio/alphafold/2.1.0  # 3.4TB data already downloaded here
model_preset=multimer
max_template_date=2022-1-1
db_preset=full_dbs                      # full_dbs, reduced_dbs

########## OUTPUTS #########
output_dir=out_alphafold_2.1.1_multimer

################################### COMMANDS ###################################
# start a process to monitor GPU usage
jobstats &

run_alphafold.py  \
 --data_dir=$DOWNLOAD_DIR  \
 --uniref90_database_path=$DOWNLOAD_DIR/uniref90/uniref90.fasta  \
 --mgnify_database_path=$DOWNLOAD_DIR/mgnify/mgy_clusters_2018_12.fa  \
 --bfd_database_path=$DOWNLOAD_DIR/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt  \
 --uniclust30_database_path=$DOWNLOAD_DIR/uniclust30/uniclust30_2021_03/UniRef30_2021_03 \
 --pdb_seqres_database_path=$DOWNLOAD_DIR/pdb_seqres/pdb_seqres.txt  \
 --template_mmcif_dir=$DOWNLOAD_DIR/pdb_mmcif/mmcif_files  \
 --obsolete_pdbs_path=$DOWNLOAD_DIR/pdb_mmcif/obsolete.dat \
 --uniprot_database_path=$DOWNLOAD_DIR/uniprot/uniprot.fasta \
 --model_preset=$model_preset \
 --max_template_date=$max_template_date \
 --db_preset=$db_preset \
 --output_dir=$output_dir \
 --fasta_paths=$protein_fasta

# create a graph of GPU resource usage stats
jobstats

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - AlphaFold:
        Jumper, John et al. "Highly accurate protein structure prediction with AlphaFold". Nature 596. 7873(2021): 583–589.

        Evans, Richard et al. Protein complex prediction with AlphaFold-Multimer
        bioRxiv 2021.10.04.463034; doi: https://doi.org/10.1101/2021.10.04.463034 
CITATIONS
