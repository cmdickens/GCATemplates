#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J blastx                 # job name
#BSUB -n 2                      # assigns 2 cores for execution
#BSUB -R "span[ptile=2]"        # assigns 2 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

<<README
    - BLAST+ manual: http://www.ncbi.nlm.nih.gov/books/NBK279675/
        - blastx: search protein databases using a translated nucleotide query
README

module load BLAST+/2.2.31-intel-2015B-Python-3.4.3

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
query='mrna_seqs_nt.fasta'

######## PARAMETERS ########
database='/scratch/datasets/blast/nr'
out_format=10

########## OUTPUTS #########
outfile='mrna_seqs_nt_blastout.csv'

################################### COMMANDS ###################################
# blastx: search protein databases using a translated nucleotide query
blastx -query $query -db $database -outfmt $out_format -out $outfile

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BLAST+:
        Camacho C., Coulouris G., Avagyan V., Ma N., Papadopoulos J., Bealer K., & Madden T.L. (2008)
        "BLAST+: architecture and applications." BMC Bioinformatics 10:421.
CITATION
