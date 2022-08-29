#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J freebayes              # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. Total memory = (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load FreeBayes/2015-12-15-intel-2015B

<<README
    - FreeBayes manual: https://github.com/ekg/freebayes
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
fasta_reference='m_tuberculosis_uid185758.fna'

# bam file must be sorted by reference position
bam_file='ERR551981_sorted.bam'

######## PARAMETERS ########

########## OUTPUTS #########
vcf_out_file='mt_ERR551981_uid185758.vcf'

################################### COMMANDS ###################################
# 
freebayes --fasta-reference $fasta_reference $bam_file > $vcf_out_file

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - FreeBayes:
        Garrison E, Marth G. Haplotype-based variant detection from short-read sequencing.
        arXiv preprint arXiv:1207.3907 [q-bio.GN] 2012.
CITATION
