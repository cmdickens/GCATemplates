#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=fastsimcoal26    # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=1           # CPUs (threads) per command
#SBATCH --mem=7500M                 # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load fastsimcoal26/2.6.0.3

<<README
    - FreeBayes manual: http://cmpg.unibe.ch/software/fastsimcoal2/man/fastsimcoal26.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
par_file='/sw/eb/sw/fastsimcoal26/2.6.0.3/example_files/1PopDNArec.par'

######## PARAMETERS ########
simulations=100             # number of simulations

########## OUTPUTS #########
output_log='out_par_file.log'

################################### COMMANDS ###################################
# Simulate data under an evolutionary scenario with parameter values defined in an input parameter file
fsc26 -i $par_file -n $simulations > $output_log

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - fastsimcoal26:
        Excoffier, L., Dupanloup, I., Huerta-Sánchez, E., Sousa, V.C., and M. Foll (2013)
        Robust demographic inference from genomic and SNP data. PLOS Genetics, 9(10):e1003905.
CITATIONS
