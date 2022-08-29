#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=qiime2           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --nodes=1                   # number of compute nodes
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load Anaconda/3-5.0.0.1
source activate qiime2-2020.2

<<README
    - qiime2 manual: https://docs.qiime2.org/2019.7/tutorials/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
input_fastq_dir='/scratch/data/bio/GCATemplates/qiime/casava-18-single-end-demultiplexed'

######## PARAMETERS ########
trim_left=0
trunc_len=0
input_format='CasavaOneEightSingleLanePerSampleDirFmt'
input_type='SampleData[SequencesWithQuality]'

########## OUTPUTS #########
demux_qza_outfile='demux-single-end_out.qza'
stats_qza_outfile='stats_out.qza'
table_qza_outfile='table_out.qza'
representative_sequences_outfile='rep-seqs_out.qza'

################################### COMMANDS ###################################

qiime tools import --type $input_type \
 --input-path $input_fastq_dir --input-format $input_format \
 --output-path $demux_qza_outfile

qiime dada2 denoise-single --i-demultiplexed-seqs $demux_qza_outfile --p-trim-left $trim_left \
 --p-trunc-len $trunc_len --o-representative-sequences $representative_sequences_outfile \
 --o-table $table_qza_outfile --o-denoising-stats $stats_qza_outfile

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - QIIME2:
        Bolyen E, et al. 2019. Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. Nature Biotechnology. 

    - Cite plugins if they were used:
        - VSEARCH:
            Rognes T, Flouri T, Nichols B, Quince C, Mahé F. (2016) VSEARCH: a versatile open source tool for metagenomics. PeerJ 4:e2584. 
        - q2-feature-classifier:
            Nicholas A. Bokulich, Benjamin D. Kaehler, Jai Ram Rideout, Matthew Dillon, Evan Bolyen, Rob Knight, Gavin A. Huttley & J. Gregory Caporaso.
            Microbiome volume 6, Article number: 90 (2018) 
CITATION
