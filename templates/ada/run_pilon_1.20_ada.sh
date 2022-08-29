#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J pilon                  # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Pilon/1.20-Java-1.8.0_92

<<README
    - Pilon homepage: https://github.com/broadinstitute/pilon/wiki
README

<<NOTE
    This script requires:
        a bam file of aligned sequence reads to an assembly as input
        a fasta file of the assembled sequences
    This scirpt can be run for testing purposes using the sample data below
NOTE
################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
assembly='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/assemblies/ERR551611_assembly_discovardenovo_pe.fasta'

######## PARAMETERS ########
sample='ERR551611'
threads=20

########## OUTPUTS #########
output_bam='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/assemblies/ERR551611_sorted_dedup.bam'

################################### COMMANDS ###################################
# You can match the java max RAM with your BSUB max RAM. if BSUB max = 52GB then use slightly less: java -Xmx50g
java -Xmx50g -jar $EBROOTPILON/pilon-1.20.jar --genome $assembly --frags $output_bam  --output $sample --outdir out_pilon --vcf --tracks --threads $threads

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Pilon:
        Bruce J. Walker, Thomas Abeel, Terrance Shea, Margaret Priest, Amr Abouelliel, Sharadha Sakthikumar,
        Christina A. Cuomo, Qiandong Zeng, Jennifer Wortman, Sarah K. Young, Ashlee M. Earl (2014)
        Pilon: An Integrated Tool for Comprehensive Microbial Variant Detection and Genome Assembly Improvement.
        PLoS ONE 9(11): e112963. doi:10.1371/journal.pone.0112963
CITATION
