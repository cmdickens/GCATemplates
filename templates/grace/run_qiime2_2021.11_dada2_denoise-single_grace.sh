#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=qiime2           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=12          # CPUs (threads) per command
#SBATCH --mem=90G                   # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load QIIME2/2021.11

<<README
    - qiime2 manual: https://docs.qiime2.org/2021.11/tutorials
                     https://docs.qiime2.org/2021.11/plugins/available/dada2/denoise-single
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# example data is already demultiplexed
emp_input_path='emp-single-end-sequences'
emp_single_end_sequences='emp-single-end-sequences.qza'
barcodes_file='sample-metadata.tsv'
demultiplexed_dir='/scratch/data/bio/GCATemplates/qiime/casava-18-single-end-demultiplexed'

######## PARAMETERS ########
emp_type='EMPSingleEndSequences'
trim_left=0
trunc_len=0                         # 0 = no truncation or length filtering
input_format='CasavaOneEightSingleLanePerSampleDirFmt'
input_type='SampleData[SequencesWithQuality]'
barcodes_column='BarcodeSequence'

########## OUTPUTS #########
per_sample_sequences='per_sample_demux.qza'
demux_qza_outfile='demux-single-end_out.qza'
stats_qza_outfile='stats_dada2_out.qza'
table_qza_outfile='table_dada2_out.qza'
representative_sequences_outfile='rep-seqs_dada2_out.qza'

################################### COMMANDS ###################################

# demux single end data; not used for example data; enable the next two commands as needed
#qiime tools import --type $emp_type  --input-path $emp_input_path \
#  --output-path $emp_single_end_sequences

#qiime demux emp-single --i-seqs $emp_single_end_sequences \
#  --m-barcodes-file $barcodes_file --m-barcodes-column $barcodes_column \
#  --output-dir $demultiplexed_dir --o-per-sample-sequences $per_sample_sequences

# import already demultiplexed single end data
qiime tools import --type $input_type \
 --input-path $demultiplexed_dir --input-format $input_format \
 --output-path $demux_qza_outfile

# upload and view your demux_summarize.qzv file at https://view.qiime2.org
qiime demux summarize \
  --i-data $demux_qza_outfile \
  --o-visualization demux_summarize.qzv

qiime dada2 denoise-single --i-demultiplexed-seqs $demux_qza_outfile --p-trim-left $trim_left \
 --p-trunc-len $trunc_len --o-representative-sequences $representative_sequences_outfile --o-table $table_qza_outfile \
 --o-denoising-stats $stats_qza_outfile

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
