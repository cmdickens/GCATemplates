#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=detonate         # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=24          # CPUs (threads) per command
#SBATCH --mem=180G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/8.3.0 OpenMPI/3.1.4 DETONATE/1.11

<<README
    - DETONATE manual: 
       rsem-eval-calculate-score [options] upstream_read_file(s) assembly_fasta_file sample_name L
       rsem-eval-calculate-score [options] --paired-end upstream_read_file(s) downstream_read_file(s) assembly_fasta_file sample_name L
       rsem-eval-calculate-score [options] --sam/--bam [--paired-end] input assembly_fasta_file sample_name L
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
assembled_transcripts='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ecoli_rna-seq_assembly_SRR575493_Trinity.fasta'
reads_fastq='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ecoli_rna-seq_reads_SRR575493.fastq'

######## PARAMETERS ########
sample_name='SRR575493'
threads=$SLURM_CPUS_PER_TASK
avg_length=50                   # For single-end data, represents the average read length.
                                # For paired-end data, represents the average fragment length.
########## OUTPUTS #########
# use default outputs

################################### COMMANDS ###################################

rsem-eval-calculate-score --num-threads $threads $reads_fastq $assembled_transcripts $sample_name $avg_length

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - DETONATE:
        Bo Li, Nathanael Fillmore, Yongsheng Bai, Mike Collins, James A. Thomson, Ron Stewart,
        and Colin N. Dewey. Evaluation of de novo transcriptome assemblies from RNA-Seq data. Genome Biology 2014, 15:553.
CITATION
