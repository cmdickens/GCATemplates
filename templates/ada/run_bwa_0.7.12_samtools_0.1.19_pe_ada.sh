#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J bwa_pe                 # job name
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
pe1_1="$SCRATCH/GCATemplates/data/sra/m_tuberculosis/ERR551981_pe_1_trimmo.fastq.gz"
pe1_2="$SCRATCH/GCATemplates/data/sra/m_tuberculosis/ERR551981_pe_2_trimmo.fastq.gz"

# look for already indexed genome here /scratch/datasets/genome_indexes/ucsc/
ref_genome="m_tuberculosis_uid185758.fna"

######## PARAMETERS ########
threads=8                       # make sure this is <= your BSUB -n value

read_group_id='mt_sra'
library='pe'
sample='ERR551981'
platform='ILLUMINA'

########## OUTPUTS #########
output_bam="${sample}_sorted.bam"

################################### COMMANDS ###################################
# NOTE index genome only if not using already indexed genome from /scratch/datasets/genome_indexes/ucsc/
if [ ! -f ${ref_genome}.bwt ]; then
  bwa index $ref_genome
fi

bwa aln -t $threads $ref_genome $pe1_1 > pe1_1.aln.sai
bwa aln -t $threads $ref_genome $pe1_2 > pe1_2.aln.sai
bwa sampe -r "@RG\tID:$read_group_id\tLB:$library\tSM:$sample\tPL:$platform" $ref_genome pe1_1.aln.sai pe1_2.aln.sai $pe1_1 $pe1_2 | samtools view -h -Sb - | samtools sort -o -m 2G -@ 8 - sorted > $output_bam


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BWA:
        Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760.

    - SAMtools:
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.
CITATION
