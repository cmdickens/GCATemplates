#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J diamond                # job name
#BSUB -n 16                     # assigns 16 cores for execution
#BSUB -R "span[ptile=16]"       # assigns 16 cores per node
#BSUB -R "rusage[mem=15000]"    # reserves 15000MB memory per core
#BSUB -M 15000                  # sets to 15000MB per process enforceable memory limit. (M * n)
#BSUB -W 168:00                 # sets to 168 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load DIAMOND/0.9.22-foss-2018b

<<README
    - DIAMOND manual: https://github.com/bbuchfink/diamond/blob/master/diamond_manual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
query='/scratch/datasets/GCATemplates/data/test/foxm1.faa'

######## PARAMETERS ########
threads=16
blast='blastp'
# use curie database on curie and ada databases on ada
database='/scratch/datasets/DIAMOND/curie/nr.dmnd'

########## OUTPUTS #########
diamond_out='foxm1_out.tsv'

################################### COMMANDS ###################################
# to see usage details run: diamond --help 
diamond $blast -d $database --query $query --out $diamond_out --threads $threads

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - DIAMOND:
        Buchfink B, Xie C, Huson DH, "Fast and sensitive protein alignment using DIAMOND",
        Nature Methods 12, 59-60 (2015). doi:10.1038/nmeth.3177
CITATION
