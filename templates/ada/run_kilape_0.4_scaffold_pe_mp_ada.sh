#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J kilape_scaffold_pe_mp  # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2000]"     # reserves 2000MB memory per core
#BSUB -M 2000                   # sets to 2000MB (~2GB) per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load KILAPE/0.4

<<README
    - KILAPE: K-masking and Iterative Local Assembly of Paired Ends

    - Output directories:
        kilape_working/iteration1/          # PE400 scaffolding
        kilape_working/iteration2/          # MP2000 scaffolding

    - NOTE: Local assembly (LA) option specified by adding LA_VELVET and VELVET_PATH or LA_CELERA and WGS_PATH in config file.
        During a local assembly, read pairs in which at least one read map unambiguously to a putative scaffold
        are segregated into a separate directory, and then a velvet or wgs assembly is performed.
        The results may break scaffolds into more contigs which ensures that the original scaffolds
        were not created using chimeric reads.
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
#files must be unzipped
pe_1='ERR551981_pe_1_trimmo.fastq'
pe_2='ERR551981_pe_2_trimmo.fastq'

mp_1='ERR760550_mp2kb_1_trimn.fastq'
mp_2='ERR760550_mp2kb_2_trimn.fastq'

config_file='lib_pe_mp_scaffold.conf'
contigs_file='../../../data/sra/m_tuberculosis/contigs_k91.fasta'

########## OUTPUTS #########
# use default outputs

######## PARAMETERS ########
threads=18                     # make sure this is <= your BSUB -n value

# create a library config file; see detailed example at the bottom of this script
echo "<LIB=PE400>
ORIENTATION=PE
INSERT_SIZE=400
INSERT_SIZE_SD=100
LOCATION1=$pe_1
LOCATION2=$pe_2

#specify mate pairs in FR orientation as PE
<LIB=MP2000>
ORIENTATION=PE
INSERT_SIZE=2000
INSERT_SIZE_SD=200
LOCATION1=$mp_1
LOCATION2=$mp_2

SCAFFOLD=PE400
SCAFFOLD=MP2000

ALIGN=BWA
BWA_PATH=$EBROOTBWA/bin

JELLYFISH_KMER_SIZE=11
JELLYFISH_HASH_SIZE=100000000 
JELLYFISH_PATH=$EBROOTJELLYFISH/bin

MAX_THREADS=$threads" > $config_file

################################### COMMANDS ###################################
# scaffold
perl $KILAPE_HOME/KILAPE.pl -a $contigs_file -c $config_file

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - KILAPE:
        http://www.ascenion.de/technologieangebote/technology-details/kilape-automated-scaffolding-and-gap-filling-of-large-complex-genomes/12ec0d1e2e6bf056443959ef62ab2786/
CITATION

<<SAMPLE_CONFIG
# First line indicates a new library and the name it should be given.
# KILAPE naming standard is <ORIENTATION><INSERTSIZE>, but can be any name.
# Name must be unique and is used in this config file and internally by KILAPE.
<LIB=PE400>
# Expected insert size of the library
INSERT_SIZE=400
# Expected standard deviation (in nucleotides)
INSERT_SIZE_SD=80
# Orientation can be PE (paired end) or MP (mate pair)
# Reads in mate pair orientation will be reverse complemented
# during read processing.
ORIENTATION=PE
# LOCATION1/LOCATION2 for non-interleaved reads. 
LOCATION1=reads/400.read1.fq
LOCATION2=reads/400.read2.fq

<LIB=MP1000>
INSERT_SIZE=1000
INSERT_SIZE_SD=200
ORIENTATION=MP
# LOCATION for interleaved reads. 
LOCATION=reads/1000.mp.fq

# Each SCAFFOLD entry represents a scaffolding iteration for the named KILAPE library
# SCAFFOLD iterations can use multiple libraries. Provide them comma separated after =
# (e.g. for LA_CELERA)
SCAFFOLD=PE400
SCAFFOLD=MP1000
# LA_CELERA or LA_VELVET used to dictate a local assembly event and which libraries
# should be used for the local assembly. 
#LA_CELERA=PE400,MP1000
LA_VELVET=PE400,MP1000
# Dictates jellyfish max memory usage. See jellyfish manual for advice on setting.
# If this memory is exceeded during k-mer counting, KILAPE will merge databases.
JELLYFISH_HASH_SIZE=100000000 
# Jellyfish kmer size. This value should be dictated by your genome size.
JELLYFISH_KMER_SIZE=11
# Maximum threads usable by each KILAPE process. Note that KILAPE will run simultaneous alignments
# for each library in a KILAPE phase, but will "nice" the later processes. If you want an absolute
# max number of threads used, set this value to <MAX THREADS>/<MAX NUMBER OF SIMULTANEOUS ALIGNMENTS>
MAX_THREADS=32
# Which aligner to use.
ALIGN=BOWTIE2
#ALIGN=BWA
#ALIGN=BOWTIE

# Note: ramdisk celera assemblies won't work if you cannot execute programs in a ramdisk.
# Comment out this line to perform local assemblies on disk (warning! I/O intensive)
# This is only relevant for local assemblies. 
RAMDISK=/dev/shm/

# Paths to each of the programs. If not provided, KILAPE will use default program (if it exists)
# in $PATH environment variable.
BWA_PATH=/home/bdownie/bin/
BOWTIE_PATH=/home/bdownie/bin/
BOWTIE2_PATH=/usr/local/bin/
WGS_PATH=/home/bdownie/src/not_me/wgs-8.1/Linux-amd64/bin/
JELLYFISH_PATH=/home/bdownie/bin/
VELVET_PATH=/home/bdownie/bin/
SAMPLE_CONFIG
