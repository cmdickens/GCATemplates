#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J snp_call_ann           # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. Total memory for job = (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load BWA/0.7.12-intel-2015B
module load SAMtools/1.3-intel-2015B
module load BCFtools/1.3-intel-2015B
module load snpEff/4.2-Java-1.7.0_80

<<README
    - BWA manual:       http://bio-bwa.sourceforge.net/bwa.shtml
    - SAMtools manual:  http://samtools.github.io/hts-specs/SAMv1.pdf
    - BCFtools manual:  https://samtools.github.io/bcftools/bcftools.html
    - snpEff manual:    http://snpeff.sourceforge.net/SnpEff_manual.html
README

################################### VARIABLES ##################################
#TODO edit this section as needed
########## INPUTS ##########
pe_1='/scratch/helpdesk/ngs/reads/DR34_R1.fastq.gz'
pe_2='/scratch/helpdesk/ngs/reads/DR34_R2.fastq.gz'

ref_genome='/scratch/helpdesk/ngs/genomes/C_dubliniensis_CD36_current_chromosomes.fasta'

######## PARAMETERS ########
threads=10                      # make sure this is <= your BSUB -n value

num_cpu4_sort=10                # make sure (num_cpu4_sort * gb_ram_per_cpu4_sort) !> total mem in GB for job
gb_ram_per_cpu4_sort=1

read_group_id='uom'
library='pe'
platform='ILLUMINA'
sample='dr34'

# to see available snpEff databases: java -jar $EBROOTSNPEFF/snpEff.jar databases > db_snpeff.txt
snpeff_database='GCA_000026945.1.29'        # Candida_dubliniensis_cd36

########## OUTPUTS #########
output_vcf="${sample}_snpeff_ann.vcf"

################################### COMMANDS ###################################
#
bwa aln -t $threads $ref_genome $pe_1 > pe_1.aln.sai
bwa aln -t $threads $ref_genome $pe_2 > pe_2.aln.sai

bwa sampe -r "@RG\tID:$read_group_id\tLB:$library\tSM:$sample\tPL:$platform" $ref_genome pe_1.aln.sai pe_2.aln.sai $pe_1 $pe_2 | samtools view -h -Sb - | samtools sort -T tmp_prefix -m ${gb_ram_per_cpu4_sort}G -@ $num_cpu4_sort - -o ${sample}_sorted.bam

# create bcf and vcf files
samtools mpileup -uf $ref_genome ${sample}_sorted.bam > ${sample}.bcf
bcftools call ${sample}.bcf -v -c -o ${sample}.vcf

# snpEff annotation analysis
# NOTE for bacterial/fungal genomes you may want to adjust the upstream/downstream option (-ud) default is 5000 bp
#      or use the options -no-upstream -no-downstream -no-intergenic since genes are so close to each other
java -Xmx8g -jar $EBROOTSNPEFF/snpEff.jar ann -v $snpeff_database ${sample}.vcf > $output_vcf

<<CITATION
    - Acknowledge TAMU HPRC: http://sc.tamu.edu/research/citation.php

    - BWA:
        Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760.

    - SAMtools:
        Li H., Handsaker B., Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.

    - BCFtools: https://samtools.github.io/bcftools/bcftools.html

    - snpEff:
        Cingolani P, Platts A, Wang le L, Coon M, Nguyen T, Wang L, Land SJ, Lu X, Ruden DM.
        A program for annotating and predicting the effects of single nucleotide polymorphisms, SnpEff:
        SNPs in the genome of Drosophila melanogaster strain w1118; iso-2; iso-3.
        Fly (Austin). 2012 Apr-Jun;6(2):80-92. doi: 10.4161/fly.19695.
CITATION
