#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J augustus               # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. Total memory = (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load AUGUSTUS/3.2.2-intel-2015B-Python-3.4.3

<<README
    - AUGUSTUS manual: http://augustus.gobics.de/binaries/README.TXT
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
genome_file='C_albicans_SC5314_A21_current_chromosomes.fasta'

######## PARAMETERS ########
# --species:  see available species here: /software/easybuild/software/AUGUSTUS/3.1-intel-2015B-Python-3.4.3/config/species/
augustus_species='candida_albicans'

prediction_start_coordinate=10000
prediction_end_coordinate=30000

########## OUTPUTS #########
gff_outfile='augustus.abinitio.gff'

################################### COMMANDS ###################################
# you don't need to change anything in this section
# rsync augustus config to home directory so you can write to the copy in your home directory
if [ ! -d "$SCRATCH/my_augustus_config/config" ]; then
  echo "Copying AUGUSTUS config directories to $SCRATCH/my_augustus_config"
  mkdir $SCRATCH/my_augustus_config
    if [ "-$EBROOTAUGUSTUS" == "-" ]; then
        echo "Augustus module not loaded"; exit 1
    fi
  rsync -rp $EBROOTAUGUSTUS/ $SCRATCH/my_augustus_config
  chmod -R 755 $SCRATCH/my_augustus_config
fi
export AUGUSTUS_CONFIG_PATH="$SCRATCH/my_augustus_config/config"

################################################################################
# augustus command with defaults; update if additional options are desired
augustus --species=$augustus_species --predictionStart=$prediction_start_coordinate --predictionEnd=$prediction_end_coordinate $genome_file > $gff_outfile

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - AUGUSTUS: Stanke M, Waack S: Gene prediction with a hidden Markov model and a new intron submodel.
        Bioinformatics 2003, 19(Suppl 2):II215-II225.
CITATION
