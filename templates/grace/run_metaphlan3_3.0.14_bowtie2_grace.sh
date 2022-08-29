#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=metaphlan3       # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=24          # CPUs (threads) per command
#SBATCH --mem=180G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/10.2.0  OpenMPI/4.0.5 MetaPhlAn/3.0.14-Python-3.8.6

<<README
    - MetaPhlAn 3.0 manual:   https://github.com/biobakery/MetaPhlAn/wiki/MetaPhlAn-3.0
    - MetaPhlAn 3.0 tutorial: https://github.com/biobakery/biobakery/wiki/metaphlan3
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
input_file='/scratch/data/bio/GCATemplates/data/illumina/gaII/SRS014459-Stool.fasta.gz'

######## PARAMETERS ########
sample='SRS014459'
input_type='fasta'              # fastq,fasta,multifasta,multifastq,bowtie2out,sam     
sensitivity='very-sensitive'    # sensitive, very-sensitive, sensitive-local, very-sensitive-local (only for fasta input)
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
outfile="${sample}.txt"

################################### COMMANDS ###################################

metaphlan $input_file --input_type $input_type --nproc $threads \
 --bt2_ps $sensitivity  --bowtie2out BM_${sample}.bt2out \
 --sample_id $sample --tmp_dir $TMPDIR -o $outfile

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - MetaPhlAn 3.0:
        Integrating taxonomic, functional, and strain-level profiling of diverse microbial communities
        with bioBakery 3 Francesco Beghini, Lauren J McIver, Aitor Blanco-Míguez, Leonard Dubois, Francesco Asnicar,
        Sagun Maharjan, Ana Mailyan, Paolo Manghi, Matthias Scholz, Andrew Maltez Thomas, Mireia Valles-Colomer,
        George Weingart, Yancong Zhang, Moreno Zolfo, Curtis Huttenhower, Eric A Franzosa, Nicola Segata. eLife (2021)
CITATION
