#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J trinity_pe_de_novo     # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB (~2.7GB) per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Trinity/2.4.0-intel-2015B-Perl-5.20.0

<<README
    - Trinity: assembles transcript sequences from Illumina RNA-Seq data.
    - Trinity manual: https://github.com/trinityrnaseq/trinityrnaseq/wiki
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe_1='/scratch/datasets/GCATemplates/data/rnaseqc/e_coli/SRR958661_1.fastq.gz'
pe_2='/scratch/datasets/GCATemplates/data/rnaseqc/e_coli/SRR958661_2.fastq.gz'

######## PARAMETERS ########
seqType='fq'                    # fa, fq
threads=20                      # make sure this is <= your BSUB -n value

<<NOTE
This version of Trinity requires either fastq headers in the new style:
    @M01581:927:000000000-ARTAL:1:1101:19874:2078 1:N:0:1

or that the fastq headers end with /1 or /2 such as:
    @M01581:927:000000000-ARTAL:1:1101:19874:2078/1

See the following link for suggested commands to add /1 and /2 to paired end or /1 to single end files if needed.
    https://hprc.tamu.edu/wiki/Ada:NGS:File_Format_Tools#Add_.2F1_or_.2F2_at_end_of_Fastq_headers
NOTE

########## OUTPUTS #########
# default trinity output is trinity_out_dir

################################### COMMANDS ###################################
# Assemble RNA-seq data; Find assembled transcripts as: 'trinity_out_dir/Trinity.fasta'
Trinity --seqType $seqType --max_memory 53G --left $pe_1 --right $pe_2 --CPU $threads --no_version_check --inchworm_cpu 6

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Trinity citation:
        Full-length transcriptome assembly from RNA-Seq data without a reference genome.
        Grabherr MG, Haas BJ, Yassour M, Levin JZ, Thompson DA, Amit I, Adiconis X, Fan L,
        Raychowdhury R, Zeng Q, Chen Z, Mauceli E, Hacohen N, Gnirke A, Rhind N, di Palma F,
        Birren BW, Nusbaum C, Lindblad-Toh K, Friedman N, Regev A.
        Nature Biotechnology 29, 644–652 (2011)
CITATION
