#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J bowtie2_se             # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 1,000MB (~1GB) per process enforceable memory limit. Total memory for job = (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Bowtie2/2.2.5-intel-2015B
module load SAMtools/1.2-intel-2015B-HTSlib-1.2.1-r2

<<README
    - Bowtie2 manual: http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
se_1='../../../data/sra/m_musculus/mm_amplicon_SRR1261611.fastq'

# use an already prefixed genome found at: /scratch/datasets/genome_indexes/ucsc/
genome_index_prefix='/scratch/datasets/genome_indexes/ucsc/mm10/bowtie2_index/mm10.fa'

######## PARAMETERS ########
threads=10                      # make sure this is <= your BSUB -n value

# rg = read group
rg_id='mm_amp'
rg_platform='ILLUMINA'
rg_sample='SRR1261611'
rg_library='sra'

########## OUTPUTS #########
output_bam='mm_amplicon_SRR1261611_se_aln.bam'

################################### COMMANDS ###################################
# add read group id and other RG values
bowtie2 -p $threads --rg-id "$rg_id" --rg "LB:$rg_library" --rg "SM:$rg_sample" --rg "PL:$rg_platform" -x $genome_index_prefix -U $se_1 | samtools view -bS - > $output_bam


<<NOTE
    When using the above command, the read group line will appear like this in the bam file:
    @RG     ID:mm_amp       LB:sra  SM:SRR1261611   PL:ILLUMINA
NOTE

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Bowtie2:
        Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.

    - SAMTools:
        Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.
CITATION
