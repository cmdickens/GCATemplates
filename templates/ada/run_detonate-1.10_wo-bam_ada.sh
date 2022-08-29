#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J detonate               # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=500]"      # reserves 500MB memory per core
#BSUB -M 500                    # sets to 500MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load DETONATE/1.10-intel-2015B-jkp
module load Bowtie/1.1.2-intel-2015B

<<README
    - DETONATE manual: 
       rsem-eval-calculate-score [options] upstream_read_file(s) assembly_fasta_file sample_name L
       rsem-eval-calculate-score [options] --paired-end upstream_read_file(s) downstream_read_file(s) assembly_fasta_file sample_name L
       rsem-eval-calculate-score [options] --sam/--bam [--paired-end] input assembly_fasta_file sample_name L
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
assembled_transcripts='/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_rna-seq_assembly_SRR575493_Trinity.fasta'
reads_fastq='/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_rna-seq_reads_SRR575493.fastq'

######## PARAMETERS ########
sample_name='test'
avg_length=50                   # For single-end data, L represents the average read length.
                                # For paired-end data, L represents the average fragment length.
########## OUTPUTS #########

################################### COMMANDS ###################################
# 
rsem-eval-calculate-score $reads_fastq $assembled_transcripts $sample_name $avg_length

<<CITATION
    - Acknowledge TAMU HPRC: http://hprc.tamu.edu/research/citation.php

    - DETONATE:
        Bo Li, Nathanael Fillmore, Yongsheng Bai, Mike Collins, James A. Thomson, Ron Stewart,
        and Colin N. Dewey. Evaluation of de novo transcriptome assemblies from RNA-Seq data. Genome Biology 2014, 15:553.
CITATION
