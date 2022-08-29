#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=minimap2         # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/10.3.0  minimap2/2.23  SAMtools/1.12

<<README
    - minimap2 Manual: https://github.com/lh3/minimap2
README

######### SYNOPSIS #########
# This script will create a genome index if needed and align pacbio reads to a
#   reference genome. Then the sam file will be coordinate sorted using samtools
#   with the final output file being a coordinate sorted bam file

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pacbio_reads='/scratch/data/bio/GCATemplates/pacbio/arabidopsis_thaliana/a_thaliana_merged2subreads.fa.gz'
reference_genome='/scratch/data/bio/ensembl_genomes/a_thaliana_tair10/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa'
reference_index='ref.mmi'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK
align_preset='map-pb'               # map-pb, map-ont, map-hifi, asm20, ava-pb, ava-ont

########## OUTPUTS #########
tmp_aln_sam="$TMPDIR/out_align.sam"
out_align_bam='a_thaliana_aln.bam'

################################### COMMANDS ###################################
# create an index if it doesn't exist
if [ ! -f "$reference_index" ]; then
    echo creating index
    minimap2 -d $reference_index $reference_genome
fi

# align reads to indexed reference genome
minimap2 -t $threads -x $align_preset -a $reference_index -o $tmp_aln_sam \
  -R "@RG\tID:$readgroup\tLB:$library\tSM:$sample\tPL:$platform" $pacbio_reads 

# coordinate sort sam file and write output to a bam file
samtools sort -m 7G --threads $threads -T $TMPDIR/tmp_sort -o $out_align_bam $tmp_aln_sam

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - minimap2: Li, H. (2018). Minimap2: pairwise alignment for nucleotide sequences. Bioinformatics, 34:3094-3100.
CITATIONS
