#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=nextflow         # job name
#SBATCH --time=01:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load Nextflow/20.10.0

<<README
    - assembly manual: https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/assembly
    - Nextflow manual: https://www.nextflow.io/docs/latest/index.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# for the sample run, git clone the repo https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/assembly
# use module git-lfs/2.11.0 to download larger fastq.gz files when cloning repo
input_dir='small_test_input'    
adapter_file='adapters.fas'
confindr_db_path='confindr_database'
workflow='main.nf'

######## PARAMETERS ########
fastq_pattern='*{R,_}*.fastq.gz'

# create nextflow.config file for singularity
echo "process.container = '/sw/hprc/biocontainers/assembly_2.0.0.sif'
singularity {
  enabled = true
  runOptions = '--bind /scratch --bind /work --no-home'
}
process.cpus = $SLURM_CPUS_PER_TASK
process.memory = $SLURM_MEM_PER_NODE
process.executor = 'local'" > nextflow.config

########## OUTPUTS #########
output_dir='assembly_output'

################################### COMMANDS ###################################

nextflow run $workflow --input_dir $input_dir --fastq_pattern "$fastq_pattern" --adapter_file $adapter_file -with-singularity --confindr_db_path $confindr_db_path --output_dir $output_dir

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Nextflow:
            Di Tommaso, P., Chatzou, M., Floden, E. W., Barja, P. P., Palumbo, E., & Notredame, C. (2017).
            Nextflow enables reproducible computational workflows. Nature Biotechnology, 35(4), 316–319. 
CITATION
