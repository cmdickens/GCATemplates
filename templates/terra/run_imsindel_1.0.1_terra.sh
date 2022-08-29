#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=imsindel         # job name
#SBATCH --time=08:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=7           # CPUs (threads) per command
#SBATCH --mem=7G                    # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load IMSindel/1.0.1-foss-2019b-Ruby-2.7.1

<<README
    - IMSindel site: https://github.com/NCGG-MGC/IMSindel
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
alignments_bam='/scratch/data/bio/GCATemplates/e_coli/bam/SRR10561103_sorted.bam'
ref_genome_fasta='/scratch/data/bio/GCATemplates/e_coli/ref/GCF_000005845.2_ASM584v2_genomic.fna'

######## PARAMETERS ########
indelsize=10000
chromosome='NC_000913.3'

########## OUTPUTS #########
outdir='out_imsindel'

################################### COMMANDS ###################################
# output directory must exist before running imsindel 
mkdir $outdir

imsindel --temp $TMPDIR --thread $SLURM_CPUS_PER_TASK --outd $outdir --bam $alignments_bam --chr $chromosome --indelsize $indelsize --reffa $ref_genome_fasta

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - IMSindel:
        Shigemizu, D., Miya, F., Akiyama, S. et al. IMSindel: An accurate intermediate-size
        indel detection tool incorporating de novo assembly and gapped global-local alignment
        with split read analysis. Sci Rep 8, 5608 (2018).
CITATION
