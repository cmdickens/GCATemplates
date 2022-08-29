#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=megahit          # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCCcore/8.2.0 MEGAHIT/1.2.8

<<README
    - MegaHit website: https://github.com/voutcn/megahit
README

######### SYNOPSIS #########
# MEGAHIT is a NGS de novo assembler for assembling large and complex metagenomics data

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe1_1='/scratch/data/bio/GCATemplates/data/metagenomic/SRR15366205_1.fastq.gz'
pe1_2='/scratch/data/bio/GCATemplates/data/metagenomic/SRR15366205_2.fastq.gz'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
out_dir='out_megahit'

################################### COMMANDS ###################################

megahit -1 $pe1_1 -2 $pe1_2 --tmp-dir $TMPDIR -t $threads -o $out_dir

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - MegaHit:
        Li, D., Liu, C-M., Luo, R., Sadakane, K., and Lam, T-W., (2015)
        MEGAHIT: An ultra-fast single-node solution for large and complex metagenomics assembly via succinct 
        de Bruijn graph. Bioinformatics, doi: 10.1093/bioinformatics/btv033 [PMID: 25609793].
        
        Li, D., Luo, R., Liu, C.M., Leung, C.M., Ting, H.F., Sadakane, K., Yamashita, H. and Lam, T.W., 2016.
        MEGAHIT v1.0: A Fast and Scalable Metagenome Assembler driven by Advanced Methodologies
        and Community Practices. Methods.
CITATION
