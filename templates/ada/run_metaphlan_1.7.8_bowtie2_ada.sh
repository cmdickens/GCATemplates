#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J metaphlan              # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load MetaPhlAn/1.7.8-intel-2015B-Python-2.7.10

<<README
    - kallisto manual: https://pachterlab.github.io/kallisto/manual
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# cat fastq files as in command below

######## PARAMETERS ########
sample='SRS015374'
input_type='multifastq'
sensitivity='very-sensitive'

########## OUTPUTS #########
outfile="profiled_samples/BM_${sample}.txt"

################################### COMMANDS ###################################
#
mkdir out_$sample

# run metaphlan.py by passing fastq reads to metaphlan.py through stdin
# this example inputs 2 paired end fastq files and one unpaired fastq file

cat ${sample}*fastq | metaphlan.py --bowtie2db $EBROOTMETAPHLAN/bowtie2db/mpa \
--bowtie2_exe $EBROOTBOWTIE2/bin/bowtie2 --bt2_ps $sensitivity --input_type $input_type --tmp_dir $TMPDIR \
--bowtie2out BM_${sample}.bt2out > $outfile

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - kallisto: http://pachterlab.github.io/kallisto/
CITATION
