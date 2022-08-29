#!/bin/bash
#SBATCH --export=NONE               # required, do not change
#SBATCH --job-name=busco4           # set job name
#SBATCH --time=1-00:00:00           # set the wall clock limit to 1 day
#SBATCH --ntasks-per-node=1         # run 1 task (command) per node
#SBATCH --cpus-per-task=28          # each task (command) uses 28 cores
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # create a file for stdout
#SBATCH --error=stderr.%j           # create a file for stderr

module load BUSCO/4.0.5-foss-2019b-Python-3.7.4

<<README
    - BUSCO manual: https://busco.ezlab.org/busco_userguide.html
    - Homepage: http://busco.ezlab.org
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
genome_file='/scratch/data/bio/gmod_genomes/C_albicans_SC5314/C_albicans_SC5314_version_A21-s02-m09-r10_chromosomes.fasta'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK
busco_mode='genome'                 # genome, transcriptome, protein
# see available BUSCO lineages in this directory: /scratch/data/bio/BUSCO/odb10/lineage/
busco_lineage='/scratch/data/bio/BUSCO/odb10/lineages/fungi_odb10'
lineage_name=$(basename $busco_lineage)

# --species:  see available species here: ls $EBROOTAUGUSTUS/config/species/
augustus_species='candida_albicans'
augustus_model='partial'            # partial (default), intronless, complete, atleastone, exactlyone

########## OUTPUTS #########
out_prefix="out_busco4_${lineage_name}_${augustus_species}"

################################### COMMANDS ###################################
# rsync augustus config to $SCRATCH
if [ ! -d "$SCRATCH/my_augustus_config/config" ]; then
  echo "Copying AUGUSTUS config directories to $SCRATCH/my_augustus_config"
  mkdir $SCRATCH/my_augustus_config
    if [ "-$EBROOTAUGUSTUS" == "-" ]; then
        echo "Augustus module not loaded"; exit 1
    fi
  rsync -r $EBROOTAUGUSTUS/ $SCRATCH/my_augustus_config
  chmod -R 755 $SCRATCH/my_augustus_config
fi
export AUGUSTUS_CONFIG_PATH="$SCRATCH/my_augustus_config/config"

busco --offline --in $genome_file --mode $busco_mode --augustus_species $augustus_species --cpu $threads --lineage_dataset $busco_lineage --out $out_prefix --augustus_parameters="--genemodel=$augustus_model"

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BUSCO:
        BUSCO: assessing genome assembly and annotation completeness with single-copy orthologs.
        Felipe A. Simão, Robert M. Waterhouse, Panagiotis Ioannidis, Evgenia V. Kriventseva, and Evgeny M. Zdobnov
        Bioinformatics, published online June 9, 2015 | doi: 10.1093/bioinformatics/btv351
CITATION
