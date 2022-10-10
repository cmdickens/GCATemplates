#!/bin/bash
#SBATCH --job-name=af2_monomer_ptm  # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=24          # CPUs (threads) per command
#SBATCH --mem=180G                  # total memory per node
#SBATCH --gres=gpu:a100:1           # request one GPU
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module purge
module load GCC/10.2.0  CUDA/11.1.1  OpenMPI/4.0.5  AlphaPickle/1.4.1

<<README
    - AlphaFold manual: https://github.com/deepmind/alphafold
README

######### SYNOPSIS #########
# this script will run the alphafold singularity container and graph .pkl files
# currently alphafold supports running on only one GPU

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
protein_fasta='/scratch/data/bio/alphafold/2.2.0/example_data/1L2Y.fasta'

######## PARAMETERS ########
DOWNLOAD_DIR='/scratch/data/bio/alphafold/2.2.0'
max_template_date='2021-1-1'        # Maximum template release date to consider. Important if folding historical test sets.
db_preset='full_dbs'                # full_dbs, reduced_dbs
model_preset='monomer_ptm'          # monomer, monomer_casp14, monomer_ptm, multimer

########## OUTPUTS #########
protein_basename=$(basename ${protein_fasta%.*})
output_dir="out_${protein_basename}_${model_preset}"
pickle_out_dir=$protein_basename

################################### COMMANDS ###################################
# enable unified memory to configure more available memory
export SINGULARITYENV_TF_FORCE_UNIFIED_MEMORY=1
export SINGULARITYENV_XLA_PYTHON_CLIENT_MEM_FRACTION=4.0

# run jobstats in the background (&) to monitor GPU usage in order to create a graph when alphafold completes
jobstats &

singularity exec --nv /sw/hprc/sw/bio/containers/alphafold/alphafold_2.2.0.sif python /app/alphafold/run_alphafold.py \
 --data_dir=$DOWNLOAD_DIR  --use_gpu_relax \
 --uniref90_database_path=$DOWNLOAD_DIR/uniref90/uniref90.fasta \
 --uniclust30_database_path=$DOWNLOAD_DIR/uniclust30/uniclust30_2021_03/UniRef30_2021_03 \
 --mgnify_database_path=$DOWNLOAD_DIR/mgnify/mgy_clusters_2018_12.fa \
 --bfd_database_path=$DOWNLOAD_DIR/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt \
 --pdb70_database_path=$DOWNLOAD_DIR/pdb70/pdb70 \
 --template_mmcif_dir=$DOWNLOAD_DIR/pdb_mmcif/mmcif_files \
 --obsolete_pdbs_path=$DOWNLOAD_DIR/pdb_mmcif/obsolete.dat \
 --model_preset=$model_preset \
 --max_template_date=$max_template_date \
 --db_preset=$db_preset \
 --output_dir=$output_dir \
 --fasta_paths=$protein_fasta

# run jobstats to create a graph of GPU usage for this job
jobstats

# graph pLDDT and PAE .pkl files
run_AlphaPickle.py -od $output_dir/$pickle_out_dir

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - AlphaFold:
        Jumper, John et al. "Highly accurate protein structure prediction with AlphaFold". Nature 596. 7873(2021): 583–589.

        Tunyasuvunakool, Kathryn et al. "Highly accurate protein structure prediction for the human proteome". Nature 596. 7873(2021): 590–596.

    - AlphaFold-multimer:
        Evans, R et al. Protein complex prediction with AlphaFold-Multimer, doi.org/10.1101/2021.10.04.463034

    - AlphaPickle
        Arnold, M. J. (2021) AlphaPickle, doi.org/10.5281/zenodo.5708709
CITATIONS

<<USAGE
  Full AlphaFold protein structure prediction script.
  flags:

/app/alphafold/run_alphafold.py:
  --[no]benchmark: Run multiple JAX model evaluations to obtain a timing that excludes the compilation time, which should be more indicative of the time required for inferencing many proteins.
    (default: 'false')
  --bfd_database_path: Path to the BFD database for use by HHblits.
  --data_dir: Path to directory of supporting data.
  --db_preset: <full_dbs|reduced_dbs>: Choose preset MSA database configuration - smaller genetic database config (reduced_dbs) or full genetic database config  (full_dbs)
    (default: 'full_dbs')
  --fasta_paths: Paths to FASTA files, each containing a prediction target that will be folded one after another. If a FASTA file contains multiple sequences, then it will be folded as a multimer. Paths should
    be separated by commas. All FASTA paths must have a unique basename as the basename is used to name the output directories for each prediction.
    (a comma separated list)
  --hhblits_binary_path: Path to the HHblits executable.
    (default: '/usr/bin/hhblits')
  --hhsearch_binary_path: Path to the HHsearch executable.
    (default: '/usr/bin/hhsearch')
  --hmmbuild_binary_path: Path to the hmmbuild executable.
    (default: '/usr/bin/hmmbuild')
  --hmmsearch_binary_path: Path to the hmmsearch executable.
    (default: '/usr/bin/hmmsearch')
  --is_prokaryote_list: Optional for multimer system, not used by the single chain system. This list should contain a boolean for each fasta specifying true where the target complex is from a prokaryote, and
    false where it is not, or where the origin is unknown. These values determine the pairing method for the MSA.
    (a comma separated list)
  --jackhmmer_binary_path: Path to the JackHMMER executable.
    (default: '/usr/bin/jackhmmer')
  --kalign_binary_path: Path to the Kalign executable.
    (default: '/usr/bin/kalign')
  --max_template_date: Maximum template release date to consider. Important if folding historical test sets.
  --mgnify_database_path: Path to the MGnify database for use by JackHMMER.
  --model_preset: <monomer|monomer_casp14|monomer_ptm|multimer>: Choose preset model configuration - the monomer model, the monomer model with extra ensembling, monomer model with pTM head, or multimer model
    (default: 'monomer')
  --obsolete_pdbs_path: Path to file containing a mapping from obsolete PDB IDs to the PDB IDs of their replacements.
  --output_dir: Path to a directory that will store the results.
  --pdb70_database_path: Path to the PDB70 database for use by HHsearch.
  --pdb_seqres_database_path: Path to the PDB seqres database for use by hmmsearch.
  --random_seed: The random seed for the data pipeline. By default, this is randomly generated. Note that even if this is set, Alphafold may still not be deterministic, because processes like GPU inference are
    nondeterministic.
    (an integer)
  --[no]run_relax: Whether to run the final relaxation step on the predicted models. Turning relax off might result in predictions with distracting stereochemical violations but might help in case you are
    having issues with the relaxation stage.
    (default: 'true')
  --small_bfd_database_path: Path to the small version of BFD used with the "reduced_dbs" preset.
  --template_mmcif_dir: Path to a directory with template mmCIF structures, each named <pdb_id>.cif
  --uniclust30_database_path: Path to the Uniclust30 database for use by HHblits.
  --uniprot_database_path: Path to the Uniprot database for use by JackHMMer.
  --uniref90_database_path: Path to the Uniref90 database for use by JackHMMER.
  --[no]use_gpu_relax: Whether to relax on GPU. Relax on GPU can be much faster than CPU, so it is recommended to enable if possible. GPUs must be available if this setting is enabled.
  --[no]use_precomputed_msas: Whether to read MSAs that have been written to disk instead of running the MSA tools. The MSA files are looked up in the output directory, so it must stay the same between multiple
    runs that are to reuse the MSAs. WARNING: This will not check if the sequence, database or configuration have changed.
    (default: 'false')
USAGE
