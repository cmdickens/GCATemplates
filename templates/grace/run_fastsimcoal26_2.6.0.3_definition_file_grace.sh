#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=fastsimcoal26    # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load fastsimcoal26/2.6.0.3

<<README
    - FreeBayes manual: http://cmpg.unibe.ch/software/fastsimcoal2/man/fastsimcoal26.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# copy input files to current directory for example run
[[ -f 1PopDNArand.tpl ]] || cp /sw/eb/sw/fastsimcoal26/2.6.0.3/example_files/1PopDNArand.tpl ./
[[ -f 1popDNA.def ]] || cp /sw/eb/sw/fastsimcoal26/2.6.0.3/example_files/1popDNA.def ./

tpl_file='1PopDNArand.tpl'
def_file='1popDNA.def'

######## PARAMETERS ########
num_batches=$SLURM_CPUS_PER_TASK
cores=0               # use 0 to let openMP choose optimal value
simulations=100

########## OUTPUTS #########
output_log='out_definition_file.log'

################################### COMMANDS ###################################
# Simulate data under an evolutionary scenario with parameter values defined in an external definition file
fsc26 --numBatches $num_batches --cores $cores -t $tpl_file -n $simulations -f $def_file > $output_log

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - fastsimcoal26:
        Excoffier, L., Dupanloup, I., Huerta-Sánchez, E., Sousa, V.C., and M. Foll (2013)
        Robust demographic inference from genomic and SNP data. PLOS Genetics, 9(10):e1003905.
CITATIONS
