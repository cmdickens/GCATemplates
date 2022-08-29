#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J gapfiller              # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB (~2.5GB) per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load GapFiller/1.10

<<README
    - GapFiller: close gaps produced by a scaffolding program using one or more mate pairs or paired-end libraries.
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe_1='../../../data/sra/m_tuberculosis/ERR551981_pe_1_trimmo.fastq.gz'
pe_2='../../../data/sra/m_tuberculosis/ERR551981_pe_2_trimmo.fastq.gz'

scaffolds_file='../../../data/sra/m_tuberculosis/contigs_k91.fasta'
config_file='lib_params.conf'

######## PARAMETERS ########
threads=8                       # make sure this is <= your BSUB -n value

########## OUTPUTS #########
output_prefix='contigs_k91'

################################### COMMANDS ###################################
# create a library config file
# NAME  ALIGNER  READS_L   READS_R  INSERT_SIZE   SIZE_STDEV  ORIENTATION
echo "lib1 bwa $pe_1 $pe_2 400 0.8 FR" > $config_file

# fill gaps with options selected for Illumina reads of length  250bp (-m 200 -t 25 -d 500 -i 2)
perl $GAPFILLER_ROOT/GapFiller.pl -s $scaffolds_file -T $threads -l $config_file -b $output_prefix -m 200 -t 25 -d 500 -i 2


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - GapFiller:
        Boetzer, M. and Pirovano, W., Toward almost closed genomes with GapFiller, Genome Biology, 13(6), 2012 
CITATION

<<USAGE
Usage: /software/tamusc/Bio/GapFiller/1.10/GapFiller.pl [GapFiller_v1-10]

============ General Parameters ============
-l  Library file containing two paired-read files with insert size, error and orientation indication.
-s  Fasta file containing scaffold sequences used for extension.
============ Extension Parameters ============
-m  Minimum number of overlapping bases with the edge of the gap (default -m 29)
-o  Minimum number of reads needed to call a base during an extension (default -o 2)
-r  Percentage of reads that should have a single nucleotide extension in order to close a gap in a scaffold (Default: 0.7)
-d  Maximum difference between the gapsize and the number of gapclosed nucleotides. Extension is stopped if it matches this parameter + gap size (default -d 50, optional).
-n  Minimum overlap required between contigs to merge adjacent sequences in a scaffold (default -n 10, optional)
-t  Number of reads to trim off the start and begin of the sequence (usually missambled/low-coverage reads) (default -t 10, optional)
-i  Number of iterations to fill the gaps (default -i 10, optional)
============ Bowtie Parameters ============
-g  Maximum number of allowed gaps during mapping with Bowtie. Corresponds to the -v option in Bowtie. (default -g 1, optional)
============ Additional Parameters ============
-T  Number of threads to run (default -T 1)
-S  Skip reading of the input files again
-b Base name for your output files (optional)
USAGE
