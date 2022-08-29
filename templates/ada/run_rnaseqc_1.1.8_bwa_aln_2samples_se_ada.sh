#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J rnaseqc                # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=2000]"     # reserves 2000MB memory per core
#BSUB -M 2000                   # sets to 2000MB per process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load RNA-SeQC/1.1.8-intel-2015B-Java-1.7.0_80

<<README
    - RNA-SeQC Manual: http://www.broadinstitute.org/cancer/cga/rnaseqc_run
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
threads=8                       # make sure this is <= your BSUB -n value

reference_fasta='Candida_albicans_sc5314_gca_000784635.GCA_000784635.1.30.dna.genome.fa'
reference_gtf='Candida_albicans_sc5314_gca_000784635.GCA_000784635.1.30.parsed.gtf'

# The .dict file will get created by PICARD but you must give it a name here; notice the name compared to the reference_fasta
reference_dict='Candida_albicans_sc5314_gca_000784635.GCA_000784635.1.30.dna.genome.dict'

# variables for bwa commands
se_1='SRR944222_1.fasta.gz'
se_2='SRR944223_1.fasta.gz'
platform='ILLUMINA'
read_group_id_1='ca_sra_1'
read_group_id_2='ca_sra_2'
library='se'
sample1='SRR944222'
sample2='SRR944223'

se_1_bam_file='SRR944222_bwa_sorted.bam'        # this is the bam file that will be created by bwa
se_2_bam_file='SRR944223_bwa_sorted.bam'        # this is the bam file that will be created by bwa

# variables for RNA-SeQC
output_dir='out_rnaseqc_bwa_rnaseqc'

sample_1_id='SRR944222'
bam_file_1='SRR944222_bwa_sorted.bam'
notes_1='4h'

sample_2_id='SRR944223'
bam_file_2='SRR944223_bwa_sorted.bam'
notes_2='76h'

################################### COMMANDS ###################################
# index genome and align reads using bwa
bwa index $reference_fasta

bwa aln $reference_fasta $se_1 | bwa samse -r "@RG\tID:$read_group_id_1\tLB:$library\tSM:$sample1\tPL:$platform" $reference_fasta - $se_1 | samtools view -h -bS - | samtools sort -o -m 2G -@ 8 - sorted > $se_1_bam_file

bwa aln $reference_fasta $se_2 | bwa samse -r "@RG\tID:$read_group_id_2\tLB:$library\tSM:$sample2\tPL:$platform" $reference_fasta - $se_2 | samtools view -h -bS - | samtools sort -o -m 2G -@ 8 - sorted > $se_2_bam_file

# Create the sample_file.tsv
echo -e "SampleID\tBam File\tNotes
$sample_1_id\t$bam_file_1\t$notes_1
$sample_2_id\t$bam_file_2\t$notes_2" > sample_file.tsv

# Create .dict sequence dictionary using picard
java -Xmx10g -jar $EBROOTPICARD/CreateSequenceDictionary.jar REFERENCE=$reference_fasta OUTPUT=$reference_dict

samtools index $bam_file_1
samtools index $bam_file_2
samtools faidx $reference_fasta

# Run RNA-SeQC with defaults
java -jar $EBROOTRNASEQC/RNA-SeQC_v1.1.8.jar -r $reference_fasta -t $reference_gtf -s sample_file.tsv -o $output_dir -singleEnd

<<NOTES
    Use -gatkFlags "-DBQ 0" if you get message: "BAM file has a read with mismatching number of bases and base qualities."
NOTES

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RNA-SeQC:
       Deluca DS, Levin JZ, Sivachenko A, Fennell T, Nazaire MD, Williams C, Reich M, Winckler W, Getz G. (2012)
       RNA-SeQC: RNA-seq metrics for quality control and process optimization. Bioinformatics.

    - BWA:
        Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760.

    - Samtools:
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.

    - PICARD: http://broadinstitute.github.io/picard/
CITATION
