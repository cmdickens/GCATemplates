#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J sspace_mp2kb           # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SSPACE-STANDARD/3.0

<<README
    estimated run time on ada:
        genome size 4.4Mb
        134,931 contigs in contigs_k91.fasta
        700,243 150bp mate paired read pairs
             ~ 2 minutes; max memory ~200Mb
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
#FR 2kb mate pairs
mp2kb1_1='../../../data/sra/m_tuberculosis/ERR760550_mp2kb_1.fastq.gz'
mp2kb1_2='../../../data/sra/m_tuberculosis/ERR760550_mp2kb_2.fastq.gz'

config_file="params_mp2kb.conf"
contigs='../../../data/sra/m_tuberculosis/contigs_k91.fasta'

######## PARAMETERS ########
threads=8                       # make sure this is <= your BSUB -n value

########## OUTPUTS #########
out_prefix='test_sspace'

################################### COMMANDS ###################################
#
echo "lib1 bwa $mp2kb1_1 $mp2kb1_2 2000 0.8 FR" > $config_file

SSPACE_Standard_v3.0.pl -l $config_file -s $contigs -x 0 -T $threads -k 5 -a 0.7 -b $out_prefix

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SSPACE:
        Marten Boetzer, Christiaan V. Henkel, Hans J. Jansen, Derek Butler and Walter Pirovano.
        Scaffolding pre-assembled contigs using SSPACE. Bioinformatics. 2011 Feb 15;27(4):578-9. doi: 10.1093/bioinformatics/btq683
CITATION
