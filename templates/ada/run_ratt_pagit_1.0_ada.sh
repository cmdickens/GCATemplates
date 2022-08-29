#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J ratt                   # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load PAGIT/1.0

<<README
    - RATT manual: http://ratt.sourceforge.net/documentation.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
query_build='F11.fasta'

######## PARAMETERS ########
# You can find reference genomes in .embl format here:
#   http://ensemblgenomes.org/info/access/ftp
# save your .embl file for the reference genome in embl_dir
embl_dir='embl'

transfer_type='Strain'
#Plese set: Transfer type: Assembly / Strain / Species / Strain.Repetitive / Strain.Global / Strain.Global.Repetitive / Species.Repetitive / Species.Global / Species.Global.Repetitive / Multiple / Free 

########## OUTPUTS #########
output_prefix='F11'

################################### COMMANDS ###################################
#
$RATT_HOME/start.ratt.sh $embl_dir $query_build $output_prefix $transfer_type

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RATT:
        Thomas D. Otto, Gary P. Dillon, Wim S. Degrave, and Matthew Berriman, RATT: Rapid Annotation Transfer Tool
        Nucleic Acids Res. 2011 May; 39(9): e57. 10.1093/nar/gkq1268
CITATION
