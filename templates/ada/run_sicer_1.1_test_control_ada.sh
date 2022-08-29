#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J sicer                  # job name
#BSUB -n 2                      # assigns 2 cores for execution
#BSUB -R "span[ptile=2]"        # assigns 2 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1,000MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SICER/1.1-intel-2017A-Python-2.7.12

<<README
    - SICER: A clustering approach for identification of enriched domains from histone modification ChIP-Seq data.
    - SICER homepage: http://home.gwu.edu/~wpeng/Software.htm
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
control_bed_file='chipseq_input_macs.bed'
test_bed_file='chipseq_enriched_macs.bed'

######## PARAMETERS ########
input_dir='./'
genome='mm8'                    # mm8, mm9, hg18, hg19, dm2, dm3, sacCer1, pombe, rn4, tair8
redundancy_threshold=1
window_size=200                 # bp
fragment_size=150               # bp
effective_genome_fraction=0.74
gap_size=600                    # bp
FDR=0.01

########## OUTPUTS #########
output_dir='output_sicer'

################################### COMMANDS ###################################
#
mkdir $output_dir

SICER.sh $input_dir $test_bed_file $control_bed_file $output_dir $genome \
 $redundancy_threshold $window_size $fragment_size $effective_genome_fraction $gap_size $FDR

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SICER:
        Xu S, Grullon S, Ge K, Peng W. Spatial Clustering for Identification of ChIP-Enriched Regions (SICER)
        to Map Regions of Histone Methylation Patterns in Embryonic Stem Cells.
        Methods in molecular biology (Clifton, NJ). 2014;1150:97-111. doi:10.1007/978-1-4939-0512-6_5.
CITATION
