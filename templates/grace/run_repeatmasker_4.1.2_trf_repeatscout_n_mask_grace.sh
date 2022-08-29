#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=repeatmask-scout # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=2           # CPUs (threads) per command
#SBATCH --mem=14G                   # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load foss/2020a RepeatMasker/4.1.2-p1-RMBlast 
module load RepeatScout/1.0.6

<<README
    RepeatMasker homepage: http://www.repeatmasker.org/
    TRF homepage: https://tandem.bu.edu/trf/trf.html
    RepeatScout manual: http://bix.ucsd.edu/repeatscout/readme.1.0.5.txt
README

######### SYNOPSIS #########
# this script will repeatmask with Ns using RepeatMasker and then
# search for repeats in the N-masked RepeatMasker output fasta using RepeatScout

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
cp /scratch/data/bio/GCATemplates/e_coli/ref/GCF_000005845.2_ASM584v2_genomic.fna ./
input_fasta='GCF_000005845.2_ASM584v2_genomic.fna'

######## PARAMETERS ########
# see the wiki page for details on pre-configured RepeatMasker species
# https://sc.tamu.edu/wiki/index.php/Ada:Bioinformatics#RepeatMasker
repeatmasker_species='fungi'
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
repeat_scout_out="out_repeatscout_${SLURM_JOBID}.fasta"

################################### COMMANDS ###################################
# RepeatMasker
RepeatMasker -s -species $repeatmasker_species -pa $threads $input_fasta
rm_out="$(basename ${input_fasta}.masked)"

# TRF
trf $rm_out 2 7 7 80 10 50 500 -m -h
rm_trf_masked_fasta="${rm_out}.2.7.7.80.10.50.500.mask"

# RepeatScout
build_lmer_table -sequence $rm_trf_masked_fasta -freq output_lmer_${SLURM_JOBID}.frequency
RepeatScout -sequence $rm_trf_masked_fasta -output $repeat_scout_out -freq output_lmer_${SLURM_JOBID}.frequency -vv
filter-stage-1.prl $repeat_scout_out > output_repeats_${SLURM_JOBID}.fas.filtered_1

# RepeatMasker
RepeatMasker $rm_trf_masked_fasta -lib output_repeats_${SLURM_JOBID}.fas.filtered_1

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RepeatMasker: Smit, AFA, Hubley, R & Green, P. RepeatMasker Open-4.0.

    - TRF: G. Benson, "Tandem repeats finder: a program to analyze DNA sequences"
         Nucleic Acids Research (1999) Vol. 27, No. 2, pp. 573-580.

    - RepeatScout: Price A.L., Jones N.C. and Pevzner P.A. 2005.  De novo identification of 
        repeat families in large genomes.  To appear in Proceedings of the
        13 Annual International conference on Intelligent Systems for
        Molecular Biology (ISMB-05).  Detroit, Michigan.
CITATION
