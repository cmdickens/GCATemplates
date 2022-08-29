#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=purge_haplotigs  # job name
#SBATCH --time=7-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load Purge_Haplotigs/1.0.3-iomkl-2017b-R-3.5.0-recommended-mt

<<README
    - Purge_Haplotigs manual:
        https://bitbucket.org/mroachawri/purge_haplotigs#markdown-header-running-purge-haplotigs
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# you will need a file named input.fofn that has a list of subreads.bam files
fofn='input.fofn'
genome='genome_assembly.fasta'

######## PARAMETERS ########
cpus=14                             # more cores = more memory requirements

########## OUTPUTS #########
subreads_merged_fasta='subreads.fasta.gz'
minimap2_out_bam='minimap2_out.bam'

################################### COMMANDS ###################################
# STEP 1. create a single fasta file from multiple subreads.bam files
bamtools merge -list $fofn | bamtools convert -format fasta | gzip > $subreads_merged_fasta

# STEP 2. align reads to genome assembly
minimap2 -ax map-pb $genome $subreads_merged_fasta -t $cpus \
    | samtools view -hF 256 - \
    | samtools sort -@ $cpus -m 1G -o $minimap2_out_bam -T tmp.aln

# STEP 3. don't use more than 14 cpus in this step; too many cpus will cause readhist to stall
purge_haplotigs readhist -b $minimap2_out_bam -g $genome -t $cpus

# TODO
# stop after step 3 in order to review the image and select low, mid and high values for STEP 4.
echo '===> Review the image and select low, mid and high values for STEP 4.'
exit

# STEP 4. MANUAL STEP
# choose cutoffs for low, mid and high coverage: https://bitbucket.org/repo/Ej8Mz7/images/84978409-phased_coverage_histogram.png
low=15
mid=72
high=175

# STEP 5.
purge_haplotigs contigcov -in ${minimap2_out_bam}.gencov -low $low -mid $mid -high $high

# STEP 6.
cpus=$SLURM_CPUS_PER_TASK
purge_haplotigs purge -g $genome -c coverage_stats.csv -t $cpus

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Purge_Haplotigs:
        Michael J. Roach, Simon A. Schmidt and Anthony R. Borneman.
        Purge Haplotigs: allelic contig reassignment for third-gen diploid genome assemblies.
        BMC Bioinformatics201819:460. https://doi.org/10.1186/s12859-018-2485-7
CITATION
