#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J gmap_se                # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load GMAP-GSNAP/2017-10-30-GCCcore-6.3.0
module load SAMtools/1.6-GCCcore-6.3.0

<<README
    - GMAP: A Genomic Mapping and Alignment Program for mRNA and EST Sequences 
    - GMAP README: http://research-pub.gene.com/gmap/src/README
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
threads=20                      # make sure this is <= your BSUB -n value
se_1='/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_transcriptome_SRR958661_R1.fastq.gz'

genome_name='CP000948'
genome='/scratch/datasets/GCATemplates/data/sra/e_coli/CP000948.fna'
genome_index_dir='/scratch/datasets/GCATemplates/data/sra/e_coli/genome_index_dir'

read_group_id='RG1'
read_group_name="$genome_name"
read_group_library='SE1'
read_group_platform='ILLUMINA'   # ILLUMINA, CAPILLARY, LS454, SOLID, HELICOS, IONTORRENT, ONT, PACBIO

gmap_output_format='samse'           # see gmap documentation for other available formats but they may be compatible with this script
bam_output="alignment_gmap_se_${genome_name}.bam"      # final sorted output bam file
################################### COMMANDS ###################################
# index the genome; you only need to do this once
if [ ! -d "$genome_index_dir/$genome_name/${genome_name}.maps" ]; then
mkdir $genome_index_dir
# if the reference genome is gzipped then use: -g $genome
gmap_build -d $genome_name -D $genome_index_dir $genome
fi

# single end read file aligned to the above genome; output is a sorted bam file
# if your read file is gzipped then use this command
zcat $se_1 | gmap -t $threads -D $genome_index_dir -d $genome_name -f $gmap_output_format --read-group-id=$read_group_id --read-group-name=$read_group_name --read-group-library=$read_group_library --read-group-platform=$read_group_platform | samtools view -Shb - | samtools sort - -T tmp_se_aln -m 2G --output-fmt BAM --threads 10 -o $bam_output

# if your read file is not gzipped then use this command
#gmap -t $threads -D $genome_index_dir -d $genome_name -f $gmap_output_format --read-group-id=$read_group_id --read-group-name=$read_group_name --read-group-library=read_group_library --read-group-platform=read_group_platform $se_1 | samtools view -Shb - | samtools sort - -T tmp_se_aln -m 2G --output-fmt BAM --threads 10 -o $bam_output

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - GSNAP:
        Thomas D. Wu and Colin K. Watanabe. GMAP: a genomic mapping and alignment program for mRNA and EST sequences.
        Bioinformatics 2005 21:1859-1875
CITATION
