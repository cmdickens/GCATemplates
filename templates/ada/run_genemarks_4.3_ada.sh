#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J genemarks              # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load GeneMarkS/4.32

<<README
    - GeneMarkS manual: 

    - Download the 64_bit key from the following website and save it to your $HOME directory.
        Select the following: GeneMark-ES v4.32  -->  LINUX 64
        (you do not need to download the program just the 64_bit key file)
            http://topaz.gatech.edu/GeneMark/license_download.cgi

        Then gunzip the key and rename it from gm_key_64 to .gm_key
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
fasta_contigs='contigs_k91.fasta'

######## PARAMETERS ########
format='GFF3'

########## OUTPUTS #########
# use output defaults

################################### COMMANDS ###################################
# To run GeneMarkS
gmsn.pl --format $format --fnn --faa --pdf --prok --verbose $fasta_contigs


# A good resource for gene finding: http://journals.plos.org/plosone/article/asset?unique&id=info:doi/10.1371/journal.pone.0050609.s001
# explanation of AED can be found here: Eilbeck et al BMC Bioinformatics 2009. 10:67

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - GeneMarkS:
        John Besemer, Alexandre Lomsadze and Mark Borodovsky. GeneMarkS: a self-training method for prediction of gene starts
        in microbial genomes. Implications for finding sequence motifs in regulatory regions.
        Nucleic Acids Research (2001) 29, pp 2607-2618 
CITATION
