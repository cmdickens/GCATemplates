#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J pblat-cluster          # job name
#BSUB -n 40                     # assigns 40 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load pblat-cluster/0.2-intel-2015B
module load OpenMPI/1.8.4-GCC-4.8.4

<<README
    - pblat-cluster manual: http://icebert.github.io/pblat-cluster/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
database='C_dubliniensis_CD36_current_chromosomes.fa'
query='C_dubliniensis_CD36_version_s01-m01-r02_orf_genomic.fasta'

######## PARAMETERS ########
threads=40

########## OUTPUTS #########
outfile='output.psl'

################################### COMMANDS ###################################
# 
mpirun -np $threads pblat-cluster $database $query $outfile

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - pblat-cluster: http://icebert.github.io/pblat-cluster/
CITATION
