#BSUB -L /bin/bash                  # use bash for job's execution environment
#BSUB -J minimap2                   # job name
#BSUB -n 20                         # assigns 20 total cores for execution
#BSUB -R "span[ptile=20]"           # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"         # reserves 2700MB memory per core
#BSUB -M 2700                       # sets to 2700MB per process enforceable memory
#BSUB -W 24:00                      # sets to 24 hour the job's runtime wall-clock limit
#BSUB -o stdout.%J                  # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J                  # directs the job's standard error to stderr.jobid

module load minimap2/2.14-GCCcore-6.4.0
module load SAMtools/1.9-GCCcore-6.4.0

<<README
    - Minimap2 manual: https://github.com/lh3/minimap2#general
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pacbio_fastq='/scratch/datasets/GCATemplates/data/pacbio/OR74A_filtered_subreads.fastq'
ref_fasta='/scratch/datasets/GCATemplates/data/pacbio/Neurospora_crassa.NC12.dna.toplevel.fa'

######## PARAMETERS ########
threads=20
preset='map-pb'                     # map-pb/map-ont: PacBio/Nanopore vs reference mapping
                                    # see minimap2 -h for more preset options
########## OUTPUTS #########
minimap2_out_bam='OR74A_N_crassa.bam'

################################### COMMANDS ###################################
# 
minimap2 -ax map-pb -t $threads $ref_fasta $pacbio_fastq \
    | samtools sort -T tmpsort -@ $threads -o $minimap2_out_bam -

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Minimap2:
        Li, H. (2018). Minimap2: pairwise alignment for nucleotide sequences.
        Bioinformatics. doi:10.1093/bioinformatics/bty191
CITATION
