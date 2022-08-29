#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J geneid                 # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load geneid/1.4.4-intel-2015B

<<README
    - geneid Manual: http://genome.crg.es/software/geneid/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
assembly='test.fa'

######## PARAMETERS ########
# get a param file from http://genome.crg.es/software/geneid/index.html#parameters
param_file="human.070123.param"

########## OUTPUTS #########
outfile='out_geneid.gff3'

################################### COMMANDS ###################################
# write predictions in gff3 format
geneid -bdaefitnxszr -3 -P $param_file $assembly > $outfile

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - geneid:
        G. Parra, E. Blanco, and R. Guigó, "Geneid in Drosophila", Genome Research 10(4):511-515 (2000). 
CITATION
