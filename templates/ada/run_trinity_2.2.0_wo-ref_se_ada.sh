#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J trinity_wo_ref_genome  # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB (~2.7GB) per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Trinity/2.2.0-intel-2015B

<<README
    - Trinity: assembles transcript sequences from Illumina RNA-Seq data.
    - Trinity manual: https://github.com/trinityrnaseq/trinityrnaseq/wiki
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
se_1='c_reinhardtii_rna_seq_SRR1179643_1.fasta'

######## PARAMETERS ########
threads=20                      # make sure this is <= your BSUB -n value
seqType='fa'                    # fa, fq
max_memory='53G'

########## OUTPUTS #########
# default output directory trinity_out_dir

################################### COMMANDS ###################################
# Assemble RNA-seq data; Find assembled transcripts as: 'trinity_out_dir/Trinity.fasta'
Trinity --seqType $seqType --max_memory $max_memory --single $se_1 --CPU $threads --no_version_check --inchworm_cpu 6

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Trinity citation:
        Full-length transcriptome assembly from RNA-Seq data without a reference genome.
        Grabherr MG, Haas BJ, Yassour M, Levin JZ, Thompson DA, Amit I, Adiconis X, Fan L,
        Raychowdhury R, Zeng Q, Chen Z, Mauceli E, Hacohen N, Gnirke A, Rhind N, di Palma F,
        Birren BW, Nusbaum C, Lindblad-Toh K, Friedman N, Regev A.
        Nature Biotechnology 29, 644–652 (2011)
CITATION
