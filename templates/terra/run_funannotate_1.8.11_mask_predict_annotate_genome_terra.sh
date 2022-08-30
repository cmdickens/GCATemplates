#!/bin/bash                                                        
#SBATCH --job-name=funannotate      # job name       
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command  
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

<<README
    - Funannotate manual: https://funannotate.readthedocs.io/en/latest
        funannotate is a pipeline for genome annotation (built specifically for fungi,
        but theoretically should work with other eukaryotes).

    - Tutorial: https://funannotate.readthedocs.io/en/latest/tutorials.html#genome-assembly-only

    - Prerequisite: download GeneMark.hmm eukaryotic (LINUX 64) from: http://topaz.gatech.edu/genemark/license_download.cgi
        gunzip gm_key_64.gz
        mv gm_key_64 ~/.gm_key
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
singularity_image='/sw/hprc/sw/bio/containers/funannotate-1.8.11-07122022.sif'
input_genome_assembly_fasta='/scratch/data/bio/GCATemplates/miseq/c_albicans/SC5314/SRR20645217_assembly.fasta'

######## PARAMETERS ########
species='candida_albicans'
busco_seed_species='dikarya'        # default: dikarya
cpus=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
clean_out_fasta='fun_clean.fasta'
sort_out_fasta='fun_sort.fasta'
mask_out_fasta='fun_mask.fasta'
predict_out_dir='fun_predict_out'
annotate_out_dir='fun_annotate_out'

################################### COMMANDS ###################################
# clean
singularity exec $singularity_image funannotate clean --input $input_genome_assembly_fasta --out $clean_out_fasta

# sort
singularity exec $singularity_image funannotate sort --input $clean_out_fasta --out $sort_out_fasta

# mask
singularity exec $singularity_image funannotate mask --cpus $cpus --input $sort_out_fasta --out $mask_out_fasta

# predict
singularity exec $singularity_image funannotate predict --cpus $cpus --tmpdir $TMPDIR --input $mask_out_fasta --out $predict_out_dir --species "$species" --busco_seed_species $busco_seed_species

# annotate
singularity exec --env EGGNOG_DATA_DIR=/scratch/data/bio/eggnogg-mapper $singularity_image funannotate annotate --cpus $cpus --tmpdir $TMPDIR --input $predict_out_dir --out $annotate_out_dir

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Funannotate: https://zenodo.org/record/2604804#.Yuk-4uzMKXI
CITATION
