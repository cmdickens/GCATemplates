#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=sailfish         # job name
#SBATCH --time=08:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load Sailfish/0.10.0-foss-2018b

<<README
    - Sailfish manual: https://sailfish.readthedocs.io/en/master/index.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
transcripts_fasta='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ecoli_rna-seq_assembly_SRR575493_Trinity.fasta'
se_reads='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ecoli_rna-seq_reads_SRR575493.fastq'

######## PARAMETERS ########
kmer=31                             # must be an odd number; max 31
libtype='U'                         # U = unstranded, S = stranded
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
index_dir='index_sailfish'
quant_dir='quant_sailfish'

################################### COMMANDS ###################################

sailfish index --threads $threads --transcripts $transcripts_fasta --kmerSize $kmer --out $index_dir
sailfish quant --threads $threads --unmatedReads $se_reads --index $index_dir --libType $libtype --output $quant_dir

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Sailfish citation:
        Rob Patro, Stephen M. Mount, and Carl Kingsford (2014) Sailfish enables alignment-free isoform quantification
        from RNA-seq reads using lightweight algorithms. Nature Biotechnology (doi:10.1038/nbt.2862)
CITATION
