#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=bowtie2_se       # job name
#SBATCH --time=06:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load Bowtie2/2.3.3.1-GCCcore-6.3.0
module load SAMtools/1.6-GCCcore-6.3.0

<<README
    - Bowtie2 manual: http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
se_1='/scratch/data/bio/GCATemplates/e_coli/rnaseq/SRR639782_1.fastq.gz'

# search for already prefixed genome found at: /scratch/data/bio/genome_indexes/
genome='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ASM80076v1.fa'
genome_index_prefix='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ASM80076v1.fa'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK

rg_id='SRR639782'
rg_sample='SRR639782'
rg_library='sra'
rg_platform='ILLUMINA'      # ILLUMINA, CAPILLARY, LS454, SOLID, HELICOS, IONTORRENT, ONT, PACBIO

########## OUTPUTS #########
output_bam="${rg_sample}.bam"

################################### COMMANDS ###################################
# build genome index if it doesn't exist
if [ ! -f ${genome_index_prefix}.1.bt2 ]; then
    bowtie2-build -f $genome $genome_index_prefix
fi

bowtie2 -p $threads --rg-id "$rg_id" --rg "LB:$rg_library" --rg "SM:$rg_sample" --rg "PL:$rg_platform" \
  -x $genome_index_prefix -q -U $se_1 | samtools view -Shb - | samtools sort - -T tmp_se_aln -m 2G --output-fmt BAM --threads 14 -o $output_bam

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Bowtie2:
        Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.

    - SAMTools:
        Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.
CITATION
