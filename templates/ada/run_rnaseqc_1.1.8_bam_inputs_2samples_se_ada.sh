#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J rnaseqc                # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 4:00                   # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load RNA-SeQC/1.1.8-intel-2015B-Java-1.7.0_80

<<README
    - RNA-SeQC Manual: http://www.broadinstitute.org/cancer/cga/rnaseqc_run
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
data_dir='/scratch/datasets/GCATemplates/data/rnaseqc/s_pyogenes'

reference_fasta="$data_dir/Streptococcus_pyogenes_m1_gas.ASM678v2.dna.toplevel.fa"
reference_gtf="$data_dir/Streptococcus_pyogenes_m1_gas.ASM678v2.32.gtf"

# The .dict file will get created by PICARD but you must give it a name here; notice the name compared to the reference_fasta
reference_dict="$data_dir/Streptococcus_pyogenes_m1_gas.ASM678v2.dna.toplevel.dict"

sample_1_id='SRR4289710'
bam_file_1="$data_dir/alignment_SRR4289710_gsnap_ASM678v2.bam"
notes_1='EC2290_1_TAP'      # notes about this sample

sample_2_id='SRR4289711'
bam_file_2="$data_dir/alignment_SRR4289711_gsnap_ASM678v2.bam"
notes_2='EC2290_2_TAP'      # notes about this sample

sample_file='sample_file.tsv'

output_dir='out_rnaseq'

################################### COMMANDS ###################################
<<UNCOMMENT_TO_INDEX
# create .dict sequence dictionary using picard
java -Xmx10g -jar $EBROOTPICARD/CreateSequenceDictionary.jar REFERENCE=$reference_fasta OUTPUT=$reference_dict
# index bam and reference files
samtools index $bam_file_1
samtools index $bam_file_2
samtools faidx $reference_fasta
UNCOMMENT_TO_INDEX

# Create the sample_file
echo -e "SampleID\tBam File\tNotes
$sample_1_id\t$bam_file_1\t$notes_1
$sample_2_id\t$bam_file_2\t$notes_2" > $sample_file

# run RNA-SeQC with defaults
java -jar $EBROOTRNASEQC/RNA-SeQC_v1.1.8.jar -r $reference_fasta -t $reference_gtf -s $sample_file -o $output_dir -singleEnd

<<NOTES
    Use -gatkFlags "-DBQ 0" if you get message: "BAM file has a read with mismatching number of bases and base qualities."
NOTES

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RNA-SeQC:
       Deluca DS, Levin JZ, Sivachenko A, Fennell T, Nazaire MD, Williams C, Reich M, Winckler W, Getz G. (2012)
       RNA-SeQC: RNA-seq metrics for quality control and process optimization. Bioinformatics.

    - Samtools:
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project
        Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9.

    - PICARD: http://broadinstitute.github.io/picard/
CITATION
