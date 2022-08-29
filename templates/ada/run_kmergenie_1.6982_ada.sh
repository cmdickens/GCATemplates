#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J kmergenie              # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1,000MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load KmerGenie/1.6982-intel-2015B-Python-2.7.10

<<README
    - KmerGenie manual: http://kmergenie.bx.psu.edu/README
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='../../../../data/sra/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe1_2='../../../../data/sra/m_tuberculosis/ERR551611_pe_2.fastq.gz'

######## PARAMETERS ########
threads=4                       # make sure this is <= your BSUB -n value

#the following kmer range was used to identify best k-mer for pared reads of 300 bp length
kmer_smallest=91    # smallest k-mer size to consider (default: 15)
kmer_largest=115    # largest k-mer size to consider (default: 121); max supported k = 121
kmer_step=4         # first pass will step at an interval of 4; second pass will narrow the k-mer range and step at interval of 2

########## OUTPUTS #########
output_prefix='ERR551611_k91_k115'

################################### COMMANDS ###################################
# create read_file and then run kmergenie using user specified k-mer range and options
echo -e "$pe1_1\n$pe1_2" > read_files

kmergenie ./read_files -k $kmer_largest -l $kmer_smallest -s $kmer_step -t $threads -o $output_prefix


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - KmerGenie:
        Rayan Chikhi and Paul Medvedev. Informed and automated k-mer size selection for genome assembly 
        Bioinformatics (2014) 30 (1): 31-37. doi: 10.1093/bioinformatics/btt310 

CITATION
