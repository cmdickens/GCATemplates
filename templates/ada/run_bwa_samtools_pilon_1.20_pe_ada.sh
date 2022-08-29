#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J pilon_pipeline         # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load BWA/0.7.12-intel-2015B
module load SAMtools/0.1.19-intel-2015B
module load picard/1.119-Java-1.7.0_80
module load Pilon/1.20-Java-1.8.0_92

<<README
    - BWA manual: http://bio-bwa.sourceforge.net/bwa.shtml
    - SAMtools manual: http://samtools.github.io/hts-specs/SAMv1.pdf
    - Pilon homepage: https://github.com/broadinstitute/pilon/wiki
README

<<NOTE
    This scirpt can be run for testing purposes using the sample data below
NOTE
################################### VARIABLES ##################################
# TODO Edit these variables as needed:
threads=20                      # make sure this is <= your BSUB -n value

pe1_1="/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR551611_pe_1.fastq.gz"
pe1_2="/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR551611_pe_2.fastq.gz"

read_group_id='mt_sra'
library='pe'
sample='ERR551611'
platform='ILLUMINA'

assembly='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/assemblies/ERR551611_assembly_discovardenovo_pe.fasta'

output_bam="${sample}_sorted_dedup.bam"

################################### COMMANDS ###################################
# NOTE index genome only if not using already indexed genome from /scratch/datasets/genome_indexes/ucsc/
if [ ! -f ${assembly}.bwt ]; then
  bwa index $assembly
fi

bwa aln -t $threads $assembly $pe1_1 > pe1_1.aln.sai
bwa aln -t $threads $assembly $pe1_2 > pe1_2.aln.sai
bwa sampe -r "@RG\tID:$read_group_id\tLB:$library\tSM:$sample\tPL:$platform" $assembly pe1_1.aln.sai pe1_2.aln.sai $pe1_1 $pe1_2 | samtools view -h -Sb - | samtools sort -o -m 2G -@ 20 - sorted > ${sample}_sorted.bam

java -jar $EBROOTPICARD/MarkDuplicates.jar TMP_DIR=$TMPDIR I=${sample}_sorted.bam O=$output_bam METRICS_FILE=${sample}.dup.metrics VALIDATION_STRINGENCY=LENIENT

samtools index $output_bam

# you can match the java max RAM with your BSUB max RAM. if BSUB max = 52GB then use slightly less: java -Xmx50g
java -Xmx50g -jar $EBROOTPILON/pilon-1.20.jar --genome $assembly --frags $output_bam  --output $sample --outdir out_pilon --vcf --tracks --threads $threads

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BWA:
        Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760.

    - SAMtools:
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.

    - Pilon:
        Bruce J. Walker, Thomas Abeel, Terrance Shea, Margaret Priest, Amr Abouelliel, Sharadha Sakthikumar,
        Christina A. Cuomo, Qiandong Zeng, Jennifer Wortman, Sarah K. Young, Ashlee M. Earl (2014)
        Pilon: An Integrated Tool for Comprehensive Microbial Variant Detection and Genome Assembly Improvement.
        PLoS ONE 9(11): e112963. doi:10.1371/journal.pone.0112963
CITATION
