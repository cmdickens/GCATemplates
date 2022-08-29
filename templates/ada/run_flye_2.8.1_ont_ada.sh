#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J flye                   # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. Total memory = (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Flye/2.8.1-intel-2019b-Python-3.7.4

<<README
    - Flye manual: https://github.com/fenderglass/Flye/blob/flye/docs/USAGE.md
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
sequence_reads='/scratch/datasets/GCATemplates/data/ont/reads/E_coli_K12_1D_R9.2_SpotON_2.pass.fasta'

######## PARAMETERS ########
input_type='--nano-raw'
threads=$LSB_MAX_NUM_PROCESSORS

########## OUTPUTS #########
out_dir='out_flye'

################################### COMMANDS ###################################
# 
flye $input_type $sequence_reads --out-dir $out_dir --threads $threads

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Flye: Mikhail Kolmogorov, Jeffrey Yuan, Yu Lin and Pavel Pevzner,
            "Assembly of Long Error-Prone Reads Using Repeat Graphs",
            Nature Biotechnology, 2019 doi:10.1038/s41587-019-0072-8
CITATION
