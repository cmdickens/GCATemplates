#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=kraken2          # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/9.3.0 OpenMPI/4.0.3 Kraken2/2.0.9-beta-Perl-5.30.2

<<'README'
    - Kraken2 Manual: https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe1_1='/scratch/data/bio/GCATemplates/data/miseq/c_dubliniensis/DR34_R1.fastq.gz'
pe1_2='/scratch/data/bio/GCATemplates/data/miseq/c_dubliniensis/DR34_R2.fastq.gz'

######## PARAMETERS ########
export KRAKEN2_DEFAULT_DB='standard'    # RefSeq for bacterial, archaeal, viral, human and UniVec_Core domains
export KRAKEN2_DB_PATH='/scratch/data/bio/kraken2'
export KRAKEN2_NUM_THREADS=$SLURM_CPUS_PERL_TASK

########## OUTPUTS #########
out_prefix='DR34'
kraken2_report="${out_prefix}_kraken2_report.tsv"
kraken2_out="${out_prefix}_kraken2_out.tsv"
class_out="${out_prefix}_kraken2_classified_out#.fq"
unclass_out="${out_prefix}_kraken2_unclassified_out#.fq"

################################### COMMANDS ###################################

kraken2 --report $kraken2_report --output $kraken2_out --classified-out $class_out \
  --unclassified-out $unclass_out --paired $pe1_1 $pe1_2

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Kraken2:
        Wood, D.E., Lu, J. & Langmead, B. Improved metagenomic analysis with Kraken 2.
        Genome Biol 20, 257 (2019). https://doi.org/10.1186/s13059-019-1891-0
CITATION
