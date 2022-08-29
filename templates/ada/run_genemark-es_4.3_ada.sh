#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J genemark-es            # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load GeneMark-ES/4.32-intel-2015B-Perl-5.20.0

<<README
    - GeneMark-ES manual: 

    - Download the 64_bit key from the following website and save it to your $HOME directory.
        Select the following: GeneMark-ES/ET v4.32  -->  LINUX 64
        (you do not need to download the program just the 64_bit key file)
            http://topaz.gatech.edu/GeneMark/license_download.cgi

        Then gunzip the key file and rename it from gm_key_64 to .gm_key
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
fasta_contigs='contigs_k91.fasta'

######## PARAMETERS ########

########## OUTPUTS #########
# use output defaults

################################### COMMANDS ###################################
# Run GeneMark-ES
gmes_petap.pl --ES --sequence $fasta_contigs

# To run GeneMark-ES using the fungal version
#gmes_petap.pl --ES  --fungi --sequence $fasta_contigs


<<NOTES
    A good resource for gene finding: http://journals.plos.org/plosone/article/asset?unique&id=info:doi/10.1371/journal.pone.0050609.s001

    An explanation of AED can be found here: doi: 10.1186/1471-2105-10-67
NOTES

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - GeneMark-ES:
        Alexandre Lomsadze et al Gene identification in novel eukaryotic genomes by self-training algorithm
        Nucleic Acids Research (2005) 33, pp 6494-6506

    - GeneMark-ES fungal version:
        Ter-Hovhannisyan et al Gene prediction in novel fungal genomes using an ab initio algorithm with unsupervised training
        Genome Research (2008) 18, pp 1979-1090 
CITATION
