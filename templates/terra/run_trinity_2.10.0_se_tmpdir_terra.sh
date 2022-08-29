#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=trinity_se       # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load Trinity/2.10.0-foss-2019b-Python-3.7.4

<<README
    - Trinity manual: https://github.com/trinityrnaseq/trinityrnaseq/wiki
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
single='/scratch/data/bio/GCATemplates/e_coli/rnaseq/SRR639782_1.fastq.gz'

######## PARAMETERS ########
seqType='fq'                        # fa, fq
max_memory='53G'
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
# output files are saved to $TMPDIR and then copied to pwd after Trinity completes

################################### COMMANDS ###################################
# all files are saved to the compute node disk so they don't count against your file quota
Trinity --seqType $seqType --max_memory $max_memory --single $single --CPU $threads --no_version_check --inchworm_cpu 6 --output $TMPDIR/trinity_out

# when Trinity is complete, the following copies the results files from the $TMPDIR to the working directory
cp $TMPDIR/trinity_out/Trinity.fasta.gene_trans_map ./
cp $TMPDIR/trinity_out/Trinity.fasta ./

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Trinity citation:
        Full-length transcriptome assembly from RNA-Seq data without a reference genome.
        Grabherr MG, Haas BJ, Yassour M, Levin JZ, Thompson DA, Amit I, Adiconis X, Fan L,
        Raychowdhury R, Zeng Q, Chen Z, Mauceli E, Hacohen N, Gnirke A, Rhind N, di Palma F,
        Birren BW, Nusbaum C, Lindblad-Toh K, Friedman N, Regev A.
        Nature Biotechnology 29, 644–652 (2011).
CITATION
