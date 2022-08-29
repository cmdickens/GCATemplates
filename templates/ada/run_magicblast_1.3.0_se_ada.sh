#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J magicblast             # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

<<README
    - Magic-BLAST: ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/README
README

module load Magic-BLAST/1.3.0-x64-linux
module load SAMtools/1.6-GCCcore-6.3.0

################################### VARIABLES ##################################
#
########## INPUTS ##########
db='/scratch/datasets/genome_indexes/ncbi/E_coli_K12/blast/U00096.2.fa'
query='/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_rnaseq_SRR933983_1.fastq.gz'

######## PARAMETERS ########
threads=20
informat='fastq'                # asn1, asn1b, fasta, fastc, fastq

########## OUTPUTS #########
outformat='sam'                 # asn, tabular, sam (default)
outfile='magicblast_out.bam'

################################### COMMANDS ###################################
#
magicblast -num_threads $threads -query $query -infmt $informat -db $db -outfmt $outformat | \
samtools sort -m 2G -@ $threads - -T tmpsort -o $outfile

<<CITATION
    - Acknowledge TAMU HPRC: http://hprc.tamu.edu/research/citation.php

    - Magic-BLAST: NA
CITATION
