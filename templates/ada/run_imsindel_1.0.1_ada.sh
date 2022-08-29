#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J imsindel               # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB per process enforceable memory limit. (M * n)
#BSUB -W 10:00                  # sets to 10 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load IMSindel/1.0.1-foss-2019b-Ruby-2.7.1

<<README
    - IMSindel site: https://github.com/NCGG-MGC/IMSindel
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
alignments_bam='/scratch/data/GCATemplates/e_coli/bam/SRR10561103_sorted.bam'
ref_genome_fasta='/scratch/data/GCATemplates/e_coli/ref/GCF_000005845.2_ASM584v2_genomic.fna'

######## PARAMETERS ########
indelsize=10000
chromosome='NC_000913.3'

########## OUTPUTS #########
outdir='out_imsindel'

################################### COMMANDS ###################################
# output directory must exist before running imsindel 
mkdir $outdir

imsindel --temp $TMPDIR --thread $LSB_MAX_NUM_PROCESSORS --outd $outdir --bam $alignments_bam --chr $chromosome --indelsize $indelsize --reffa $ref_genome_fasta

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - IMSindel:
        Shigemizu, D., Miya, F., Akiyama, S. et al. IMSindel: An accurate intermediate-size
        indel detection tool incorporating de novo assembly and gapped global-local alignment
        with split read analysis. Sci Rep 8, 5608 (2018).
CITATION
