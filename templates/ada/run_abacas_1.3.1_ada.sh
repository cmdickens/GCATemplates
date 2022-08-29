#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J abacas                 # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=500]"      # reserves 500MB memory per core
#BSUB -M 500                    # sets to 500MB per process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load PAGIT/1.0-intel-2015B

<<README
    - ABACAS Manual: http://abacas.sourceforge.net/Manual.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
contigs='454AllContigs.fna'

# The reference genome must be a single fasta sequence.
# For eukaryotic genomes, you must concatenate all contigs, scaffolds, chromosomes into a single fasta sequence.
# This script may be useful: $PAGIT_HOME/ABACAS/joinMultifasta.pl
reference='SS_SC84.dna'

########## OUTPUTS #########
# use output defaults

################################### COMMANDS ###################################
# 
perl $PAGIT_HOME/ABACAS/abacas.pl -r $reference -q $contigs -p nucmer

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    Swain MT, Tsai IJ, Assefa SA, Newbold C, Berriman M, Otto TD. A post-assembly genome-improvement toolkit (PAGIT)
    to obtain annotated genomes from contigs. Nature protocols 2012;7;7;1260-84.
    PUBMED: 22678431; PMC: 3648784; DOI: 10.1038/nprot.2012.068
CITATION

<<USAGE
abacas.pl -r <reference file: single fasta> -q <query sequence file: fasta> -p <nucmer/promer>  [OPTIONS]

        -r      reference sequence in a single fasta file
        -q      contigs in multi-fasta format
        -p      MUMmer program to use: 'nucmer' or 'promer'
OR
abacas.pl -r <reference file: single fasta>  -q <pseudomolecule/ordered sequence file: fasta> -e 
OPTIONS
        -h              print usage
        -d              use default nucmer/promer parameters 
        -s      int     minimum length of exact matching word (nucmer default = 12, promer default = 4)
        -m              print ordered contigs to file in multifasta format 
        -b              print contigs in bin to file 
        -N              print a pseudomolecule without "N"s 
        -i      int     mimimum percent identity [default 40]
        -v      int     mimimum contig coverage [default 40]
        -V      int     minimum contig coverage difference [default 1]
        -l      int     minimum contig length [default 1]
        -t              run tblastx on contigs that are not mapped 
        -g      string (file name)      print uncovered regions (gaps) on reference to file name
        -n      int     insert n Ns between overlapping contigs [default 100]
        -a              append contigs in bin to the pseudomolecule
        -o      prefix  output files will have this prefix
        -P              pick primer sets to close gaps
        -f      int     number of flanking bases on either side of a gap for primer design (default 350)
        -R      int     Run mummer [default 1, use -R 0 to avoid running mummer]
        -e              Escape contig ordering i.e. go to primer design
        -c              Reference sequence is circular
USAGE
