#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J art_illumina_se        # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load ART/2016.06.05-intel-2016b

<<README
    - ART homepage: http://www.niehs.nih.gov/research/resources/software/biostatistics/art/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
input_fasta='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/C_dubliniensis_CD36_current_chromosomes.fasta'

######## PARAMETERS ########
sequences_system='MSv3'       # GA1, GA2, HS10, HS20, HS25, HSXn, HSXt, MSv1, MSv3, MinS, NS50
read_length=250
fold_coverage=60

########## OUTPUTS #########
output_prefix='c_dubliniensis'

################################### COMMANDS ###################################
# Single end reads witout printing alignments (-na)
art_illumina -i $input_fasta -l $read_length -ss $sequences_system -f $fold_coverage -o $output_prefix -na


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - ART:
        Weichun Huang, Leping Li, Jason R Myers, and Gabor T Marth. ART: a next-generation sequencing read simulator,
        Bioinformatics (2012) 28 (4): 593-594
CITATION
