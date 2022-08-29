#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J gsnap                  # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid
#BSUB -P project_ID             # This is the project number against which the used service units (SUs) are charged.

module load GMAP-GSNAP/2018-07-04-GCCcore-6.3.0
module load SAMtools/1.8-GCCcore-6.3.0

<<README
    - GSNAP: Genomic Short-read Nucleotide Alignment Program 
    - GSNAP manual: http://research-pub.gene.com/gmap/src/README
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
se_1='../../../data/sra/m_tuberculosis/ERR551611_se_trimmo.fastq.gz'
genome='../../../data/sra/m_tuberculosis/CP000948.fna'

######## PARAMETERS ########
threads=18                      # make sure this is <= your BSUB -n value
genome_name='CP000948'

########## OUTPUTS #########
output_prefix="alignment_gsnap_${genome_name}"

################################### COMMANDS ###################################
# index the genome; you only need to do this once
mkdir genome_dir
# if the reference genome is gzipped then use: -g $genome
gmap_build -d $genome_name -D genome_dir $genome

# single end read file aligned to the above genome; output is a sorted bam file
gsnap -t $threads -D genome_dir --gunzip -d $genome_name --format=sam --read-group-id=rg1 --read-group-name=$genome_name --read-group-library=PE01 --read-group-platform=illumina $se_1 | samtools view -Shb - | samtools sort - $output_prefix

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - GSNAP:
        Thomas D. Wu and Colin K. Watanabe. GMAP: a genomic mapping and alignment program for mRNA and EST sequences.
        Bioinformatics 2005 21:1859-1875
CITATION
