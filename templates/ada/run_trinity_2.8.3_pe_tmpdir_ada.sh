#BSUB -L /bin/bash              # uses the bash login for the job's execution environment.
#BSUB -J trinity_pe_tmpdir      # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB (~2.7GB) per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Trinity/2.8.3-GCCcore-6.3.0-Python-2.7.12-bare
module load Python/2.7.12-intel-2017A

<<README
    - Trinity manual: https://github.com/trinityrnaseq/trinityrnaseq/wiki
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe_1='/scratch/datasets/GCATemplates/data/rnaseqc/e_coli/SRR958661_1.fastq.gz'
pe_2='/scratch/datasets/GCATemplates/data/rnaseqc/e_coli/SRR958661_2.fastq.gz'

######## PARAMETERS ########
max_memory='53G'
seqType='fq'                    # fa, fq
threads=20                      # make sure this is <= your BSUB -n value

########## OUTPUTS #########
# output files are saved to $TMPDIR and then copied to pwd after Trinity completes

################################### COMMANDS ###################################
# all files are saved to the compute node disk so they don't count against your file quota
Trinity --seqType $seqType --max_memory $max_memory --left $pe_1 --right $pe_2 --CPU $threads --no_version_check --inchworm_cpu 6 --output $TMPDIR/trinity_out

# when Trinity is complete, copy the results files from the $TMPDIR to the working directory
cp $TMPDIR/trinity_out/Trinity.fasta.gene_trans_map ./
cp $TMPDIR/trinity_out/Trinity.fasta ./

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Trinity citation:
        Full-length transcriptome assembly from RNA-Seq data without a reference genome.
        Grabherr MG, Haas BJ, Yassour M, Levin JZ, Thompson DA, Amit I, Adiconis X, Fan L,
        Raychowdhury R, Zeng Q, Chen Z, Mauceli E, Hacohen N, Gnirke A, Rhind N, di Palma F,
        Birren BW, Nusbaum C, Lindblad-Toh K, Friedman N, Regev A.
        Nature Biotechnology 29, 644–652 (2011).
CITATION
