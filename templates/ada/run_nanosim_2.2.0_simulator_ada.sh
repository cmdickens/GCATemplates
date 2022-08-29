#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J nanosim                # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load NanoSim/2.2.0-intel-2017A-Python-2.7.12

<<README
    - NanoSim manual: https://github.com/bcgsc/NanoSim
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
fasta_reference='/scratch/datasets/GCATemplates/data/ont/ref/ecoli_K12_MG1655.fasta'
fasta_2d_file='/scratch/datasets/GCATemplates/data/ont/reads/E_coli_K12_1D_R9.2_SpotON_2.pass.fasta'

######## PARAMETERS ########
threads=20

########## OUTPUTS #########
output_prefix='ecoli'

################################### COMMANDS ###################################
# simulate Oxford Nanopore reads 
read_analysis.py -t $threads -i $fasta_2d_file -r $fasta_reference -o $output_prefix

simulator.py circular -r $fasta_reference -c $output_prefix


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - NanoSim: https://github.com/bcgsc/NanoSim
CITATION
