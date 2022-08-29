#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J srst2                  # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 8:00                   # sets to 8 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SRST2/0.2.0-intel-2015B-Python-2.7.10

<<README
    - SRST manual: https://github.com/katholt/srst2
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
mlst_db='/scratch/datasets/GCATemplates/data/srst2/LEE_mlst.fasta'
mlst_def='/scratch/datasets/GCATemplates/data/srst2/LEE_profiles.txt'

r1_1='/scratch/datasets/GCATemplates/data/srst2/ERR178156_1.fastq.gz'
r1_2='/scratch/datasets/GCATemplates/data/srst2/ERR178156_2.fastq.gz'
r2_1='/scratch/datasets/GCATemplates/data/srst2/ERR178148_1.fastq.gz'
r2_2='/scratch/datasets/GCATemplates/data/srst2/ERR178148_2.fastq.gz'

######## PARAMETERS ########

########## OUTPUTS #########
output_prefix='LEE'

################################### COMMANDS ###################################
# the getmlst.py step must be run on the login node command line since the compute nodes do not have internet access
# run this command in your working directory prior to submitting your job script; select your organism: http://pubmlst.org/databases/
#getmlst.py --species "Candida albicans"

# run srst2 on sample srst2 data
srst2 --input_pe $r1_1 $r1_2 $r2_1 $r2_2 --output $output_prefix --log --mlst_db $mlst_db --mlst_definitions $mlst_def

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SRST2:
        Michael Inouye, Harriet Dashnow, Lesley-Ann Raven, Mark B Schultz, Bernard J Pope, Takehiro Tomita, Justin Zobel and Kathryn E Holt
        2014, SRST2: Rapid genomic surveillance for public health and hospital microbiology labs
        Genome Medicine, 6:90. DOI: 10.1186/s13073-014-0090-6
CITATION
