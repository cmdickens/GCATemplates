#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=sailfish         # job name
#SBATCH --time=08:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/7.3.0-2.30 OpenMPI/3.1.1 Sailfish/0.10.0

<<README
    - Sailfish manual: https://sailfish.readthedocs.io/en/master/index.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
transcripts_fasta='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ecoli_rna-seq_assembly_SRR575493_Trinity.fasta'
se_reads='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ecoli_rna-seq_reads_SRR575493.fastq'

######## PARAMETERS ########
kmer='31'                           # must be an odd number; max 31
libtype='U'                         # U = unstranded, S = stranded
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
index_dir='index_sailfish'
quant_dir='quant_sailfish'

################################### COMMANDS ###################################

sailfish index --threads $threads --out $index_dir --transcripts $transcripts_fasta --kmerSize $kmer && \
sailfish quant --threads $threads --output $quant_dir --unmatedReads $se_reads --index $index_dir --libType $libtype

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Sailfish citation:
        Rob Patro, Stephen M. Mount, and Carl Kingsford (2014) Sailfish enables alignment-free isoform quantification
        from RNA-seq reads using lightweight algorithms. Nature Biotechnology (doi:10.1038/nbt.2862)
CITATION
