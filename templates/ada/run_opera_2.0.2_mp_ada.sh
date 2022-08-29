#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J opera_mp               # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Opera/2.0.2

<<README
    - Opera: Opera (Optimal Paired-End Read Assembler) is a sequence assembly program.
    - Homepage: http://sourceforge.net/projects/operasf/ 
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
contigs='../../../data/sra/m_tuberculosis/contigs_k91.fasta'
config_file='opera_mp_build.conf'

# FR 2kb mate pairs
mp2kb1_1='../../../data/sra/m_tuberculosis/ERR760550_mp2kb_1.fastq.gz'
mp2kb1_2='../../../data/sra/m_tuberculosis/ERR760550_mp2kb_2.fastq.gz'

########## OUTPUTS #########
output_dir='opera_results'

######## PARAMETERS ########
# to see sample contig files look in the directory $OPERA_ROOT/test_dataset/ after loading Opera module
# TODO Edit these parameters as needed according to your data set
echo "output_folder=$output_dir
contig_file=$contig_file
kmer=91
filter_repeat=no

[LIB]
map_file=opera_preprocess_mp.bam
cluster_threshold=5
lib_mean=2000
lib_std=500" > $config_file

################################### COMMANDS ###################################
#
perl $OPERA_ROOT/bin/preprocess_reads.pl $contigs $mp2kb1_1 $mp2kb1_2  opera_preprocess_mp.bam bwa

$OPERA_ROOT/bin/opera $config_file

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Opera:
        Gao S, Sung WK, and Nagarajan N. Opera: reconstructing optimal genomic scaffolds with high-throughput paired-end sequences.
        J Comput Biol. 2011 Nov;18(11):1681-91. doi: 10.1089/cmb.2011.0170
CITATION

<<SAMPLE_SINGLE_LIB_CONFIG
#
# Essential Parameters
#

# Output folder for final results
output_folder=test_dataset/results

# Contig file
contig_file=test_dataset/contigs.fa

# value of kmer used to produce contig file
kmer=39

# Specify if repeats will be scaffolded or not
# no: scaffold repeats
# yes: do not scaffold repeats (default)
#filter_repeat=no

# specify value of ploidy, defaule value is 1
#ploidy=1

# coverage for haploid sequence can also be specified (recommend to calculate this value by OPERA-LG)
#haploid_coverage=10

# Mapped read locations
[LIB]
map_file=test_dataset/lib_1.bam
cluster_threshold=5
#lib_mean=10000
#lib_std=1000
SAMPLE_SINGLE_LIB_CONFIG
