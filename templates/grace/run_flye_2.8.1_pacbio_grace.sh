#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=flye             # job name
#SBATCH --time=01:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load iccifort/2020.1.217 impi/2019.7.217 Flye/2.8.1-Python-3.8.2

<<README
    - Flye manual: https://github.com/fenderglass/Flye/blob/flye/docs/USAGE.md
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
input_fasta='/scratch/data/bio/GCATemplates/pacbio/ecoli/E.coli_PacBio_40x.fasta'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
out_dir='out_ecoli_pacbio'

################################### COMMANDS ###################################

flye --pacbio-raw $input_fasta --out-dir $out_dir --threads $threads

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Flye (choose the most appropriate):
        Mikhail Kolmogorov, Jeffrey Yuan, Yu Lin and Pavel Pevzner, "Assembly of Long Error-Prone Reads
        Using Repeat Graphs", Nature Biotechnology, 2019 doi:10.1038/s41587-019-0072-8

        Mikhail Kolmogorov, Mikhail Rayko, Jeffrey Yuan, Evgeny Polevikov, Pavel Pevzner,
        "metaFlye: scalable long-read metagenome assembly using repeat graphs", bioRxiv, 2019 doi:10.1101/637637

        Yu Lin, Jeffrey Yuan, Mikhail Kolmogorov, Max W Shen, Mark Chaisson and Pavel Pevzner,
        "Assembly of Long Error-Prone Reads Using de Bruijn Graphs", PNAS, 2016 doi:10.1073/pnas.1604560113
CITATIONS
