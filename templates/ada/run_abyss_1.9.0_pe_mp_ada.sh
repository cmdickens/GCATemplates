#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J abyss_pe_mp            # job name
#BSUB -n 40                     # uses 40 cores
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB (~2.7GB) per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load ABySS/1.9.0-intel-2015B-Python-2.7.10
unset LSF_BINDIR

<<README
    read the official ABySS Manual
    https://github.com/bcgsc/abyss#abyss

    estimated run time: ~3 minutes; max memory ~5Gb
        genome size 4.4Mb
        210,924 300bp read pairs (Illumina)
        317,161 qc trimmed mate paired read pairs (Illumina Nextera)

    smaller kmer values require more memory than larger values
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe1_2='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR551611_pe_2.fastq.gz'

mp1_1='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR760550_mp2kb_1.fastq.gz'
mp1_2='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR760550_mp2kb_2.fastq.gz'

######## PARAMETERS ########
mpi_threads=40              # make sure this <= your BSUB -n value
serial_threads=20           # this should match the span[ptile=NN] value
kmer=128                    #max kmer available is 128
min_pairs4scaffolding=5     #indicates 5 mate pairs needed to join contigs

########## OUTPUTS #########
prefix='build_abyss_1pe_1mp2kb'

################################### COMMANDS ###################################
# command to run with defaults
# np is the number of threads to use during the assembly
# -j is number of theads for post assembly steps and is recommended to be around the number of libraries used
abyss-pe j=$serial_threads np=$mpi_threads k=$kmer n=$min_pairs4scaffolding name=$prefix lib='lib1' mp='mp1' lib1="$pe1_1 $pe1_2" mp1="$mp1_1 $mp1_2"

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - ABySS:
        Simpson, J. T., Wong, K., Jackman, S. D., Schein, J. E., Jones, S. J., & Birol, I. (2009).
        ABySS: a parallel assembler for short read sequence data. Genome research, 19(6), 1117-1123.
CITATION
