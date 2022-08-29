#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=hisat2           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=56G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

<<README
    - HISAT2 manual: http://ccb.jhu.edu/software/hisat2/manual.shtml
README

module load HISAT2/2.2.1-foss-2018b-Python-3.6.6
module load SAMtools/1.9-foss-2018b

######### SYNOPSIS #########
# This template script aligns paired end reads and sorts the output into a bam file

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe_1='/scratch/data/bio/GCATemplates/miseq/a_fumigatus/DRR022927_1.fastq.gz'
pe_2='/scratch/data/bio/GCATemplates/miseq/a_fumigatus/DRR022927_2.fastq.gz'

# you can use an already prefixed genome found at: /scratch/data/bio/genome_indexes/
genome_index_prefix='/scratch/data/bio/genome_indexes/gmod/Aspergillus_fumigatus_Af293/hisat2/A_fumigatus_Af293'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK
# read group information
id='af_amp'
library='sra'
platform='ILLUMINA'
sample='DRR022927'

########## OUTPUTS #########
output_bam="${sample}_pe_aln.bam"

################################### COMMANDS ###################################
# If you will be using cufflinks downstream, run hisat2 with the --dta-cufflinks option instead of --dta
hisat2 --dta -p $threads --rg-id "$id" --rg "LB:$library" --rg "SM:$sample" --rg "PL:$platform" -x $genome_index_prefix -q -1 $pe_1 -2 $pe_2 -S $TMPDIR/out.sam

samtools view -bS $TMPDIR/out.sam | samtools sort -m 2G -@ $threads - -T $TMPDIR/$sample -o $output_bam

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - HISAT2:
        Kim D, Langmead B and Salzberg SL. HISAT: a fast spliced aligner with low memory requirements.
        Nature Methods 12, 357–360 (2015). doi:10.1038/nmeth.3317

CITATION
