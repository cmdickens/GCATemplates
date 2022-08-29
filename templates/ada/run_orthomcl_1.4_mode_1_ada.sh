#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J orthomcl               # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 72:00                  # sets to 72 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load OrthoMCL/1.4-intel-2015B-Perl-5.20.0

<<README
    - OrthoMCL 1.4 manual: $EBROOTORTHOMCL/README
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
<<NOTE
    You must create a directory called sample_data in your working directory and put all your input files there
NOTE

# you can find sample data in the directory: $EBROOTORTHOMCL/sample_data
# comma separated list of fasta files in your ./sample_data/ directory
fa_files='Ath.fa,Hsa.fa,Sce.fa'

num_threads=10                  # make sure this is <= your BSUB -n value
################################### COMMANDS ###################################
# 
if [ ! -d "sample_data" ]; then
    echo "====================" 1>&2
    echo "ERROR:" 1>&2
    echo "You must create a directory called sample_data and put all your input files there" 1>&2
    exit 1
fi

export BLAST_CPUS=$num_threads

orthomcl.pl --mode 1 --fa_files $fa_files

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - OrthoMCL:
        Li Li, Christian J. Stoeckert, Jr., and David S. Roos
        OrthoMCL: Identification of Ortholog Groups for Eukaryotic Genomes
        Genome Res. 2003 13: 2178-2189
CITATION
