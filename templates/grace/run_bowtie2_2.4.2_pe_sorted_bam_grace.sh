#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=bowtie2_pe       # job name
#SBATCH --time=06:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/10.2.0 Bowtie2/2.4.2
module load SAMtools/1.11

<<README
    - Bowtie2 manual: http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe_1='/scratch/data/bio/GCATemplates/e_coli/rnaseq/SRR639782_1.fastq.gz'
pe_2='/scratch/data/bio/GCATemplates/e_coli/rnaseq/SRR639782_2.fastq.gz'

# search for already prefixed genome found at: /scratch/data/bio/genome_indexes/
genome='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ASM80076v1.fa'
genome_index_prefix='/scratch/data/bio/GCATemplates/e_coli/rnaseq/ASM80076v1.fa'

######## PARAMETERS ########
rg_id='SRR639782'
rg_sample='SRR639782'
rg_library='sra'
rg_platform='ILLUMINA'  # ILLUMINA, CAPILLARY, LS454, SOLID, HELICOS, IONTORRENT, ONT, PACBIO

threads=$SLURM_CPUS_PER_TASK
sort_threads=$((SLURM_CPUS_PER_TASK / 2))
sort_mem=$((SLURM_MEM_PER_NODE / sort_threads))

########## OUTPUTS #########
output_bam="${rg_sample}.bam"

################################### COMMANDS ###################################
# build genome index if it doesn't exist
if [ ! -f ${genome_index_prefix}.1.bt2 ]; then
    bowtie2-build -f $genome $genome_index_prefix
fi

bowtie2 -p $threads --rg-id "$rg_id" --rg "LB:$rg_library" --rg "SM:$rg_sample" --rg "PL:$rg_platform" -x $genome_index_prefix \
  -q -1 $pe_1 -2 $pe_2 | samtools view -Shb - | samtools sort - -T $TMPDIR/tmp_se_aln -m ${sort_mem}M --output-fmt BAM --threads $sort_threads -o $output_bam

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Bowtie2:
        Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.

    - SAMTools:
        Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.
CITATION
