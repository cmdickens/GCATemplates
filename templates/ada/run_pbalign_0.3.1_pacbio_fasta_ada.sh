#BSUB -L /bin/bash              # uses the bash login shell for job environment
#BSUB -J pbalign                # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit.
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load pbalign/0.3.1-GCCcore-6.4.0
source $EBROOTPBALIGN/setup-env.sh

<<README
    - pbalign manual: https://github.com/PacificBiosciences/pbalign/blob/master/doc/howto.rst
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pacbio_reads='/scratch/datasets/GCATemplates/data/pacbio/human/Chr1_HG002_subset.fasta'
ref_genome='/scratch/datasets/GCATemplates/data/pacbio/human/Homo_sapiens.GRCh38.dna.chromosome.1.fa'

######## PARAMETERS ########
threads=20                       # make sure this is <= your BSUB -n value

########## OUTPUTS #########
output='out.pbalign.sam'

################################### COMMANDS ###################################
#
pbalign --nproc $threads --tmpDir $TMPDIR $pacbio_reads $ref_genome $output


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - pbalign: https://github.com/PacificBiosciences/pbalign
CITATION
