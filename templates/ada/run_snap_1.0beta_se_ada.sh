#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J snap_se                # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. Total memory for job = (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SNAP/1.0beta.18

<<README
    - SNAP manual: http://snap.cs.berkeley.edu/downloads/snap-1.0beta-manual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# read files can be compressed
se1='ERR551981_pe_1_trimmo.fastq.gz'

# look for already indexed genome here /scratch/datasets/genome_indexes/
ref_genome="m_tuberculosis_uid185758.fna"

######## PARAMETERS ########

########## OUTPUTS #########
output_sam="out_ERR551981_se.sam"

################################### COMMANDS ###################################
# index genome only if not using already indexed genome from /scratch/datasets/genome_indexes/
#mkdir index_dir
#snap-aligner index $ref_genome index_dir

snap-aligner single index_dir $se1 -o $output_sam


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SNAP:
        Faster and More Accurate Sequence Alignment with SNAP. Matei Zaharia, William J. Bolosky, Kristal Curtis,
        Armando Fox, David Patterson, Scott Shenker, Ion Stoica, Richard M. Karp, and Taylor Sittler. arXiv:1111.5572v1, November 2011.
CITATION
