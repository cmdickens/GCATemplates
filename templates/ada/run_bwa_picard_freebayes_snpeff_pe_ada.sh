#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J freebayes              # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load BWA/0.7.12-intel-2015B
module load SAMtools/1.2-intel-2015B-HTSlib-1.2.1-r2
module load picard/1.119-Java-1.7.0_80
module load FreeBayes/2015-12-15-intel-2015B
module load snpEff/4.2-Java-1.7.0_80

<<README
    - FreeBayes manual: https://github.com/ekg/freebayes
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe1_1='/scratch/datasets/GCATemplates/data/miseq/a_fumigatus/DRR022927_1.fastq.gz'
pe1_2='/scratch/datasets/GCATemplates/data/miseq/a_fumigatus/DRR022927_2.fastq.gz'

ref_genome="/scratch/datasets/ncbi_genomes/Aspergillus_fumigatus_Af293/A_fumigatus_Af293_version_s03-m05-r05_chromosomes.fasta"

######## PARAMETERS ########
threads=20                      # make sure this is <= your BSUB -n value

# the following three lines are used by bwa to add read group information
library='PRJDB3064'
readgroup='PRJDB3064'
platform='ILLUMINA'     # ILLUMINA,SLX,SOLEXA,SOLID,454,COMPLETE,PACBIO,IONTORRENT,CAPILLARY,HELICOS,UNKNOWN

# to see available snpEff databases: java -jar $EBROOTSNPEFF/snpEff.jar databases > db_snpeff.txt
snpeff_database='A_fumigatus_Af293_version_s03-m05-r05'

########## OUTPUTS #########
sample='DRR022927'

output_vcf="${sample}_snpeff_cds.vcf"

################################### COMMANDS ###################################
#
bwa mem -M -t $threads -R "@RG\tID:$readgroup\tLB:$library\tSM:$sample\tPL:$platform" $ref_genome $pe1_1 $pe1_2 > ${sample}_1.bwa_sampe_out.sam

# sort sam picard; validation is because some reads align past the end of the reference chromosome
java -Xmx48g -jar $EBROOTPICARD/SortSam.jar TMP_DIR=$TMPDIR I=${sample}_1.bwa_sampe_out.sam O=${sample}_1_sorted.bam SO=coordinate VALIDATION_STRINGENCY=LENIENT

# mark duplicates with picard
java -jar $EBROOTPICARD/MarkDuplicates.jar TMP_DIR=$TMPDIR I=${sample}_1_sorted.bam O=${sample}_1_sorted_dedup.bam METRICS_FILE=${sample}_1.dup.metrics VALIDATION_STRINGENCY=LENIENT

# index bam files
samtools index ${sample}_1_sorted_dedup.bam

# call variants
freebayes --fasta-reference $ref_genome ${sample}_1_sorted_dedup.bam > ${sample}.vcf

# annotate variants
java -Xmx48g -jar $EBROOTSNPEFF/snpEff.jar ann -v -no-upstream -no-downstream -no-intergenic $snpeff_database ${sample}.vcf > $output_vcf

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BWA:
        Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760.

    - PICARD: http://broadinstitute.github.io/picard/

    - SAMtools:
        Li H., Handsaker B., Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.

    - GATK citation
        A framework for variation discovery and genotyping using next-generation DNA sequencing data
        DePristo M, Banks E, Poplin R, Garimella K, Maguire J, Hartl C, Philippakis A, del Angel G, Rivas MA,
        Hanna M, McKenna A, Fennell T, Kernytsky A, Sivachenko A, Cibulskis K, Gabriel S, Altshuler D, Daly M,
        2011 Nature Genetics 43:491-498
        - also see: https://www.broadinstitute.org/gatk/about/citing

    - FreeBayes:
        Garrison E, Marth G. Haplotype-based variant detection from short-read sequencing.
        arXiv preprint arXiv:1207.3907 [q-bio.GN] 2012.

    - snpEff:
        Cingolani P, Platts A, Wang le L, Coon M, Nguyen T, Wang L, Land SJ, Lu X, Ruden DM.
        A program for annotating and predicting the effects of single nucleotide polymorphisms, SnpEff:
        SNPs in the genome of Drosophila melanogaster strain w1118; iso-2; iso-3.
        Fly (Austin). 2012 Apr-Jun;6(2):80-92. doi: 10.4161/fly.19695.
CITATION
