#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J trimmomatic            # job name
#BSUB -n 2                      # assigns 2 cores for execution
#BSUB -R "span[ptile=2]"        # assigns 2 cores per node
#BSUB -R "rusage[mem=15000]"    # reserves 15000MB memory per core
#BSUB -M 15000                  # sets to 15000MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Trimmomatic/0.39-Java-1.8.0

<<README
    - Trimmomatic manual:
        http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/DR34_R1.fastq.gz'
pe1_2='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/DR34_R2.fastq.gz'

######## PARAMETERS ########
threads=2                       # make sure this is <= your BSUB -n value
min_length=40
quality_format="-phred33"       # -phred33, -phred64    # see https://en.wikipedia.org/wiki/FASTQ_format#Encoding 

# available adapter files:
#   Nextera:      NexteraPE-PE.fa
#   GAII:         TruSeq2-PE.fa, TruSeq2-SE.fa
#   HiSeq,MiSeq:  TruSeq3-PE-2.fa, TruSeq3-PE.fa, TruSeq3-SE.fa
adapter_file='TruSeq3-PE.fa'

########## OUTPUTS #########
prefix='DR34'

################################### COMMANDS ###################################
#
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar \
PE -threads $threads $quality_format $pe1_1 $pe1_2 -baseout ${prefix}_trimmo.fastq.gz \
ILLUMINACLIP:$EBROOTTRIMMOMATIC/adapters/$adapter_file:2:30:10 \
MINLEN:$min_length


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Trimmomatic:
        Anthony M. Bolger1,2, Marc Lohse1 and Bjoern Usadel. Trimmomatic: A flexible trimmer for Illumina Sequence Data.
        Bioinformatics. 2014 Aug 1;30(15):2114-20. doi: 10.1093/bioinformatics/btu170.
CITATION
