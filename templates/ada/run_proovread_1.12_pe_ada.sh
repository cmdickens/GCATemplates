#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J proovread              # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "select[mem256gb]"     # use 256GB memory node
#BSUB -R "rusage[mem=12300]"    # reserves 12300MB memory per core
#BSUB -M 12300                  # sets to 12300MB (~12GB) the per process enforceable memory limit.
#BSUB -W 168:00                 # sets to 168 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Proovread/2.12-intel-2015B
module load blasr/2016-01-27
module load Perl_tamu/5.20.0-intel-2015B

<<README
    - Proovread manual: https://github.com/BioInf-Wuerzburg/proovread/blob/master/README.pdf?raw=true
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='../bbnorm/sxpx_trimmo_bbnorm_60x_1.fq'
pe1_2='../bbnorm/sxpx_trimmo_bbnorm_60x_2.fq'

pacbio_reads='All_PACBIO_Reads.fastq'

######## PARAMETERS ########
threads=20

########## OUTPUTS #########
out_prefix='results_out'

################################### COMMANDS ###################################
#
proovread --threads $threads -l $pacbio_reads -s $pe1_1 -s $pe1_2 --pre $out_prefix

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Proovread:
        proovread: large-scale high accuracy PacBio correction through iterative short read consensus.
        Hackl, T.; Hedrich, R.; Schultz, J.; Förster, F. in Bioinformatics (2014).
CITATION
