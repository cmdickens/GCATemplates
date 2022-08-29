#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=repeatmasker     # job name
#SBATCH --time=01:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=24          # CPUs (threads) per command
#SBATCH --mem=180G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/9.3.0  OpenMPI/4.0.3  RepeatMasker/4.1.2-p1-HMMER

<<README
    RepeatMasker homepage: http://www.repeatmasker.org
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# comment out or delete the following line when using your own input_fasta file
[ -f upstream5000.fa.gz ] || cp /scratch/data/bio/GCATemplates/data/test/upstream5000.fa.gz ./
input_fasta='upstream5000.fa.gz'

######## PARAMETERS ########
# see species taxonomy with the following command:
# famdb.py --help
# famdb.py names thaliana
species='Arabidopsis thaliana'
threads=$SLURM_CPUS_PER_TASK
masking='-xsmall'       # -xsmall returns repetitive regions in lowercase (rest capitals) rather than masked
                        # -small returns complete .masked sequence in lower case
                        # -x returns repetitive regions masked with Xs rather than Ns (default Ns)

########## OUTPUTS #########
# use default outputs

################################### COMMANDS ###################################

RepeatMasker -s -species "$species" -pa $threads -e hmmer $masking $input_fasta

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RepeatMasker: Smit, AFA, Hubley, R & Green, P. RepeatMasker Open-4.0.
                    2013-2015 <http://www.repeatmasker.org>.
CITATIONS
