#!/bin/bash
#SBATCH --job-name=metaphlan4       # job name
#SBATCH --time=10:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=24          # CPUs (threads) per command
#SBATCH --mem=180G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module purge
module load GCC/10.2.0 OpenMPI/4.0.5 MetaPhlAn/4.0.2-Python-3.8.6

<<README
    - MetaPhlAn 4.0 manual:   https://github.com/biobakery/MetaPhlAn
    - MetaPhlAn 4.0 tutorial: https://github.com/biobakery/biobakery/wiki/metaphlan4
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# use a comma separated list of single end or paired end files.
input_file='/scratch/data/bio/GCATemplates/data/metagenomic/metaphlan4/SRS014459-Stool.fasta.gz,/scratch/data/bio/GCATemplates/data/metagenomic/metaphlan4/SRS014476-Supragingival_plaque.fasta.gz'

######## PARAMETERS ########
sample='SRS014459-76'
input_type='fasta'                  # fastq,fasta,multifasta,multifastq,bowtie2out,sam     
sensitivity='sensitive'             # sensitive, very-sensitive, sensitive-local, very-sensitive-local (only for fasta input)
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

    - MetaPhlAn 4.0:
        Extending and improving metagenomic taxonomic profiling with uncharacterized species with MetaPhlAn 4.
        Aitor Blanco-Miguez, Francesco Beghini, Fabio Cumbo, Lauren J. McIver, Kelsey N. Thompson, Moreno Zolfo, 
        Paolo Manghi, Leonard Dubois, Kun D. Huang, Andrew Maltez Thomas, Gianmarco Piccinno, Elisa Piperni, 
        Michal Punčochář, Mireia Valles-Colomer, Adrian Tett, Francesca Giordano, Richard Davies, Jonathan Wolf, 
        Sarah E. Berry, Tim D. Spector, Eric A. Franzosa, Edoardo Pasolli, Francesco Asnicar, Curtis Huttenhower, 
        Nicola Segata. Preprint (2022)
CITATION
