#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=bwa_pe           # job name
#SBATCH --time=24:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load SAMtools/1.9-intel-2018b
module load BWA/0.7.17-intel-2018b

<<README
    - BWA manual: http://bio-bwa.sourceforge.net/bwa.shtml
    - SAMtools manual: http://samtools.github.io/hts-specs/SAMv1.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe1_1='/scratch/data/bio/GCATemplates/e_coli/seqs/SRR10561103_1.fastq.gz'
pe1_2='/scratch/data/bio/GCATemplates/e_coli/seqs/SRR10561103_2.fastq.gz'
# look for already indexed genome here /scratch/data/bio/genome_indexes/ucsc/
ref_genome='/scratch/data/bio/GCATemplates/e_coli/ref/GCF_000005845.2_ASM584v2_genomic.fna'

######## PARAMETERS ########
cpus=$SLURM_CPUS_PER_TASK
readgroup='ecoli_sra'
library='pe'
sample='SRR10561103'
platform='ILLUMINA'

########## OUTPUTS #########
output_bam="${sample}_sorted.bam"

################################### COMMANDS ###################################
# NOTE index genome only if not using already indexed genome
if [ ! -f ${ref_genome}.bwt ]; then
  bwa index $ref_genome
fi

bwa mem -M -t $cpus -R "@RG\tID:$readgroup\tLB:$library\tSM:$sample\tPL:$platform" $ref_genome $pe1_1 $pe1_2 | \
  samtools view -h -Sb - | samtools sort -o $output_bam -m 2G -@ $cpus -T tmp4sort -

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/wiki/index.php/HPRC:AckUs

    - BWA:
        Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760.

    - SAMtools:
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.
CITATION
