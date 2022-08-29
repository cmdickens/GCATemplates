#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J bwa_se                 # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. Total memory for job = (M * n)
#BSUB -W 8:00                   # sets to 8 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load BWA/0.7.12-intel-2015B
module load SAMtools/0.1.19-intel-2015B

<<README
    - BWA manual: http://bio-bwa.sourceforge.net/bwa.shtml
    - SAMtools manual: http://samtools.github.io/hts-specs/SAMv1.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
se_1='../../../data/sra/m_musculus/mm_amplicon_SRR1261611.fastq'

ref_genome='/scratch/datasets/genome_indexes/ucsc/mm10/bwa_0.7.12_index/mm10.fa'

######## PARAMETERS ########
threads=8                       # make sure this is <= your BSUB -n value

read_group_id='mm_sra'
library='se'
sample='SRR1261611'
platform='ILLUMINA'

########## OUTPUTS #########
output_bam="out_${sample}_bwa_sorted.bam"

################################### COMMANDS ###################################
# NOTE index genome only if not using already indexed genome from /scratch/datasets/genome_indexes/ucsc/
if [ ! -f ${ref_genome}.bwt ]; then
  bwa index $ref_genome
fi

bwa aln $ref_genome $se_1 | bwa samse -r "@RG\tID:$read_group_id\tLB:$library\tSM:$sample\tPL:$platform" $ref_genome - $se_1 | samtools view -h -bS - | samtools sort -o -m 2G -@ 8 - sorted > $output_bam

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BWA:
        Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760.

    - SAMtools:
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.
CITATION
