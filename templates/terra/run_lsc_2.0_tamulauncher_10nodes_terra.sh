#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=lsc_10nodes      # job name
#SBATCH --time=7-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --nodes=10                  # total number of nodes
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load LSC/2.0-intel-2017A-Python-2.7.12

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
illumina='/scratch/data/bio/GCATemplates/nist/h_sapiens/illumina_trios/2A1_CGATGT_L001_R2_001.fastq.gz'
illumina_read_type='fq'             # fq, fa, cps

pacbio='/scratch/data/bio/GCATemplates/nist/h_sapiens/pacbio_trios/BWA-MEM_Chr1_HG002_merged_11_12.gt25kb.fasta'

######## PARAMETERS ########
aligner='bowtie2'                   # bowtie2, hisat
cpus=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
prefix="lsc_gt25kb"
lsc_tmp="${prefix}_tmpdir"
lsc_results="${prefix}_results"
batch_cmd_file="${prefix}_cmds.txt"

################################### COMMANDS ###################################
# MODE 1    takes just a few minutes
runLSC.py --mode 1 --specific_tempdir $lsc_tmp --short_read_file_type $illumina_read_type \
--short_reads $illumina --long_reads $pacbio --aligner $aligner

count=$(cat $lsc_tmp/batch_count)
rm $batch_cmd_file

for i in $( eval echo {1..$count} ); do
echo "runLSC.py --threads $cpus --parallelized_mode_2 $i --specific_tempdir $lsc_tmp" >> $batch_cmd_file
done

# MODE 2    takes about 3.5 hours for sample dataset
tamulauncher --commands-pernode 1 $batch_cmd_file
echo "finished tamulauncher"

# MODE 3    takes just a few minutes
runLSC.py --mode 3 --specific_tempdir $lsc_tmp --output $lsc_results

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - LSC: Kin Fai Au, Jason Underwood, Lawrence Lee and Wing Hung Wong
            Improving PacBio Long Read Accuracy by Short Read Alignment
            PLoS ONE 2012. 7(10): e46679. doi:10.1371/journal.pone.0046679
CITATION
