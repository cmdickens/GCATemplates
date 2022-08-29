#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J seqtk                  # job name
#BSUB -n 2                      # assigns 2 cores for execution
#BSUB -R "span[ptile=2]"        # assigns 2 cores per node
#BSUB -R "rusage[mem=500]"      # reserves 500MB memory per core
#BSUB -M 500                    # sets to 500MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Seqtk/1.2-intel-2015B

<<README
    - Seqtk manual: https://github.com/lh3/seqtk
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
read1='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR551981_pe_1.fastq.gz'
read2='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR551981_pe_2.fastq.gz'

subsample_fraction='0.1'        # keep 10%

random_seed=100                 # (remember to use the same random seed to keep pairing)

################################### COMMANDS ###################################
# 
seqtk sample -s$random_seed $read1 $subsample_fraction > subsample_1_${subsample_fraction}.fq &
seqtk sample -s$random_seed $read2 $subsample_fraction > subsample_2_${subsample_fraction}.fq &
wait

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Seqtk: not available
CITATION
