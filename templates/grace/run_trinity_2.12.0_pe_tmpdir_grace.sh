#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=trinity          # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/9.3.0 OpenMPI/4.0.3 Trinity/2.12.0-Python-3.8.2

<<README
    - Trinity manual: https://github.com/trinityrnaseq/trinityrnaseq/wiki
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe_1='/scratch/data/bio/GCATemplates/e_coli/rnaseq/SRR639782_1.fastq.gz'
pe_2='/scratch/data/bio/GCATemplates/e_coli/rnaseq/SRR639782_2.fastq.gz'

######## PARAMETERS ########
seqType='fq'                        # fa, fq
max_memory='355G'
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
# output files are saved to $TMPDIR and then copied to pwd after Trinity completes

################################### COMMANDS ###################################
# all files are saved to the compute node disk so they don't count against your file quota
Trinity --seqType $seqType --max_memory $max_memory --left $pe_1 --right $pe_2 --CPU $threads --no_version_check --inchworm_cpu 6 --output $TMPDIR/trinity_out

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
