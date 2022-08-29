#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J hisat2                 # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2,700MB (~2.7GB) per process enforceable memory limit. Total job memory = (M * n)
#BSUB -W 24:00                  # sets to 24 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load HISAT2/2.1.0-intel-2017A-Python-2.7.12
module load SAMtools/1.6-GCCcore-6.3.0

<<README
    - HISAT2 manual: http://ccb.jhu.edu/software/hisat2/manual.shtml
README

# This template script aligns paired end reads and sorts the output into a bam file

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe_1='/scratch/datasets/GCATemplates/data/miseq/a_fumigatus/DRR022927_1.fastq.gz'
pe_2='/scratch/datasets/GCATemplates/data/miseq/a_fumigatus/DRR022927_2.fastq.gz'

# you can use an already prefixed genome found at: /scratch/datasets/ucsc/genome_indexes/
genome_index_prefix='/scratch/datasets/genome_indexes/gmod_genomes/Aspergillus_fumigatus_Af293/hisat2/A_fumigatus_Af293'

######## PARAMETERS ########
threads=20                      # make sure this is <= your BSUB -n value
# read group information
id='af_amp'
library='sra'
platform='ILLUMINA'
sample='DRR022927'

########## OUTPUTS #########
output_bam="${sample}_pe_aln.bam"

################################### COMMANDS ###################################
# If you will be using cufflinks downstream, run hisat2 with the --dta-cufflinks option instead of --dta
hisat2 --dta -p $threads --rg-id "$id" --rg "LB:$library" --rg "SM:$sample" --rg "PL:$platform" -x $genome_index_prefix -q -1 $pe_1 -2 $pe_2 -S out.sam

samtools view -bS out.sam | samtools sort -m 2G -@ $threads - -T $sample -o $output_bam

rm out.sam

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - HISAT2:
        Kim D, Langmead B and Salzberg SL. HISAT: a fast spliced aligner with low memory requirements.
        Nature Methods 12, 357–360 (2015). doi:10.1038/nmeth.3317

CITATION
