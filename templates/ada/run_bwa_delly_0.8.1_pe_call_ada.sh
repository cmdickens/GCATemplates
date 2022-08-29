#BSUB -L /bin/bash              # uses the bash login shell for job environment
#BSUB -J bwa2delly              # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit.
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load BWA/0.7.17-intel-2018b
module load picard/2.18.27-Java-1.8.0
module load SAMtools/1.9-intel-2018b
module load Delly/0.8.1-intel-2018b
module load BCFtools/1.9-intel-2018b

<<README
    - BWA manual: http://bio-bwa.sourceforge.net/bwa.shtml
    - SAMtools manual: http://samtools.github.io/hts-specs/SAMv1.pdf
    - Delly Manual: https://github.com/dellytools/delly
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# look for already indexed genome here /scratch/datasets/genome_indexes/
ref_genome='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/m_tuberculosis_uid185758.fna'

pe1_1='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR551611_pe_1_trimmo.fastq.gz'
pe1_2='/scratch/datasets/GCATemplates/data/sra/m_tuberculosis/ERR551611_pe_2_trimmo.fastq.gz'

######## PARAMETERS ########
export OMP_NUM_THREADS=1        # (delly) number of threads should equal the number of samples in the input vcf file

read_group='ERR551981'
library='pe'
sample='ERR551981'
platform='ILLUMINA'             # ILLUMINA, CAPILLARY, LS454, SOLID, HELICOS, IONTORRENT, ONT, PACBIO

threads=20                      # make sure this is <= your BSUB -n value

########## OUTPUTS #########
out_bcf_file='ERR551981_delly.bcf'
out_vcf_file='ERR551981_delly.vcf'

################################### COMMANDS ###################################
# create genome bwa index only if it hasn't been created yet
if [ ! -f ${ref_genome}.bwt ]; then
  bwa index $ref_genome
fi

bwa mem -M -t $threads -R "@RG\tID:$read_group\tLB:$library\tSM:$sample\tPL:$platform" $ref_genome $pe1_1 $pe1_2 > $TMPDIR/${sample}_bwa_sampe_out.sam

# sort sam picard; validation is because some reads align past the end of the reference chromosome
java -Xmx48g -jar $EBROOTPICARD/picard.jar SortSam TMP_DIR=$TMPDIR I=$TMPDIR/${sample}_bwa_sampe_out.sam O=$TMPDIR/${sample}_sorted.bam SO=coordinate VALIDATION_STRINGENCY=LENIENT

# mark duplicates with picard
java -jar $EBROOTPICARD/picard.jar MarkDuplicates TMP_DIR=$TMPDIR I=$TMPDIR/${sample}_sorted.bam O=${sample}_sorted_dedup.bam METRICS_FILE=${sample}_dup.metrics VALIDATION_STRINGENCY=LENIENT

# index bam files
samtools index ${sample}_sorted_dedup.bam

# call variants with delly 
delly call --genome $ref_genome --outfile $out_bcf_file ${sample}_sorted_dedup.bam

# create a vcf file from the bcf file
bcftools view $out_bcf_file > $out_vcf_file

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BWA:
        Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760.

    - SAMtools:
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.

    - Delly: 
        Tobias Rausch, Thomas Zichner, Andreas Schlattl, Adrian M. Stuetz, Vladimir Benes, Jan O. Korbel.
        Delly: structural variant discovery by integrated paired-end and split-read analysis.
        Bioinformatics 2012 28: i333-i339.
CITATION
