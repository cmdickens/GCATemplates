#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J macs14                 # job name
#BSUB -n 2                      # assigns 2 cores for execution
#BSUB -R "span[ptile=2]"        # assigns 2 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1,000MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid
#BSUB -P project_ID             # This is the project number against which the used service units (SUs) are charged.

module load MACS/1.4.2-1-goolf-1.7.20-Python-2.7.10

<<README
    - MACS: Model-based Analysis for ChIP-Sequencing

    - MACS homepage:
        http://liulab.dfci.harvard.edu/MACS/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
control_bed_file='../../../data/chipseq/chipseq_input_macs.bed'
test_bed_file='../../../data/chipseq/chipseq_enriched_macs.bed'

######## PARAMETERS ########

########## OUTPUTS #########
output_prefix='chipseq_macs_test'

################################### COMMANDS ###################################
# command to run with defaults
macs14 -c $control_bed_file -t $test_bed_file -n $output_prefix

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - MACS:
        Zhang et al. Model-based Analysis of ChIP-Seq (MACS). Genome Biol (2008) vol. 9 (9) pp. R137.
CITATION
