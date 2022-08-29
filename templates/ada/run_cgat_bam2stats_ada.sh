#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J cgat_bam2stats         # job name
#BSUB -n 1                      # assigns 1 core for execution
#BSUB -R "span[ptile=1]"        # assigns 1 core per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load CGAT/0.2.4

<<README
    - CGAT homepage: https://www.cgat.org/downloads/public/cgat/documentation/index.html#
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
bam_in='ERR551981_sorted.bam'
fastq_in='ERR551981_pe_1_trimmo.fastq.gz'

######## PARAMETERS ########

########## OUTPUTS #########
stats_out='ERR551981_sorted_stats.out'  # will be created at runtime

################################### COMMANDS ###################################
# source the activate script to load required applications in the environment
source $CGAT_ACTIVATE cgat-scripts

# run the bam2stats tool
cgat bam2stats --fastq-file=$fastq_in  -L log.out -E error.out -S $stats_out < $bam_in

# remove the CGAT environment
source deactivate

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - CGAT:
        Sims D, Ilott NE, Sansom SN, Sudbery IM, Johnson JS, Fawcett KA, Berlanga-Taylor AJ, Luna-Valero S, Ponting CP, Heger A.
        CGAT: computational genomics analysis toolkit. Bioinformatics. 2014 May 1;30(9):1290-1.
        doi: 10.1093/bioinformatics/btt756. Epub 2014 Jan 5.
CITATION

