#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=busco            # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/10.2.0 OpenMPI/4.0.5 BUSCO/5.1.2

<<README
    - BUSCO manual: https://busco.ezlab.org/busco_userguide.html
    - Homepage: http://busco.ezlab.org
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
genome_file='/scratch/data/bio/GCATemplates/miseq/c_dubliniensis/C_dubliniensis_CD36_current_chromosomes.fasta'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK

busco_mode='genome'                 # genome, transcriptome, proteins
busco_lineage='fungi_odb10'         # check available databases at /scratch/data/bio/busco5/lineages/
download_path='/scratch/data/bio/busco5'    # use this if database is available

########## OUTPUTS #########
out_prefix="out_busco5_${busco_lineage}"

################################### COMMANDS ###################################
# use --offline if database is available at /scratch/data/bio/busco5/lineages/

busco --offline --in $genome_file --mode $busco_mode --cpu $threads --lineage $busco_lineage --out $out_prefix --download_path $download_path

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BUSCO:
        BUSCO: assessing genome assembly and annotation completeness with single-copy orthologs.
        Felipe A. Simão, Robert M. Waterhouse, Panagiotis Ioannidis, Evgenia V. Kriventseva, and Evgeny M. Zdobnov
        Bioinformatics, published online June 9, 2015 | doi: 10.1093/bioinformatics/btv351
CITATION
