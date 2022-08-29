#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J snap_hmm               # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB per process enforceable memory limit. Total memory for job = (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SNAP-HMM/2013-11-29-intel-2015B

<<README
    - A useful link about SNAP-HMM usage:
        https://www.psc.edu/index.php/user-resources/software/snap
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
transcripts='transcripts.fasta'
proteins='proteins.fasta'

# you can find some pre-compiled snap hmm models here: /software/tamusc/Bio/SNAP-HMM/2013-02-16/snap/HMM/
snap_hmm="$SNAPHMM_HOME/HMM/worm"
scaffolds="$SNAPHMM_HOME/DNA/worm.dna.gz"

######## PARAMETERS ########

########## OUTPUTS #########
outfile='output.gff'

################################### COMMANDS ###################################
# 
snap $snap_hmm $scaffolds -gff -aa $proteins -tx $transcripts > $outfile


# A good resource for gene finding: http://journals.plos.org/plosone/article/asset?unique&id=info:doi/10.1371/journal.pone.0050609.s001

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SNAP-HMM: http://korflab.ucdavis.edu/software.html
CITATION
