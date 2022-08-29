#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J speedseq               # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SpeedSeq/0.1.2-foss-2017A-Python-2.7.12

<<'README'
    - SpeedSeq manual: https://github.com/hall-lab/speedseq#usage
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='/scratch/datasets/GCATemplates/data/miseq/a_fumigatus/DRR022927_1.fastq.gz'
pe1_2='/scratch/datasets/GCATemplates/data/miseq/a_fumigatus/DRR022927_2.fastq.gz'

reference='/scratch/datasets/gmod_genomes/Aspergillus_fumigatus_Af293/A_fumigatus_Af293_version_s03-m05-r05_chromosomes.fasta'

######## PARAMETERS ########
threads=20
sample_name='DRR022927'

########## OUTPUTS #########
outprefix="out_speedseq_${sample_name}"

################################### COMMANDS ###################################
# command to run with defaults
speedseq align -t $threads -R "@RG\tID:$sample_name\tSM:$sample_name\tLB:pelib" -o $outprefix $reference $pe1_1 $pe1_2

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SpeedSeq citation:
        C Chiang, R M Layer, G G Faust, M R Lindberg, D B Rose, E P Garrison, G T Marth,
        A R Quinlan, and I M Hall. SpeedSeq: ultra-fast personal genome analysis and interpretation.
        Nat Meth (2015). doi:10.1038/nmeth.3505.
CITATION
