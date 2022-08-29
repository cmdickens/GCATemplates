#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J cuffdiff               # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Bowtie2/2.2.6-intel-2015B
module load TopHat/2.1.0-intel-2015B
module load Cufflinks/2.2.1-intel-2015B

<<README
    - Bowtie2 manual - http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml
    - Cufflinks manual - http://cole-trapnell-lab.github.io/cufflinks/manual/
    - TopHat manual - https://ccb.jhu.edu/software/tophat/index.shtml
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
########## OUTPUTS #########

# ref genome must end with .fa
ref_genome="C_parapsilosis_CDC317_current_chromosomes.fa"

# the ref_genome minus the .fa extension; no need to edit this variable if ref_genome ends in .fa
ref_genome_prefix="${ref_genome%.fa}"

# gtf file descibing coding regions and other features
ref_gtf="C_parapsilosis_CDC317_version_s01-m03-r11_features.gtf"

# exclude mito features if desired; if not desired, remove the --mask-file option below
ref_mask_gtf="C_parapsilosis_CDC317_version_s01-m03-r11_Mt_features.gtf"

sample_prefixes=( DR18 DR19 DR21 DR22 )

# in the same order as the samples in sample_prefixes above
sample_file_names=( DR18_sequence.txt.gz DR19_sequence.txt.gz DR21_sequence.txt.gz DR22_sequence.txt.gz )

######## PARAMETERS ########
threads=20

########## OUTPUTS #########
# see outputs in commands below

################################### COMMANDS ###################################
# index genome (only needs to be done once): look in /scratch/datasets/genome_indexes for already indexed genomes
bowtie2-build $ref_genome $ref_genome_prefix

# intialize a file that will contain a list of GTF file names
cat /dev/null > assembly_GTF_list.txt

i=0
for sample in "${sample_prefixes[@]}"
do
    sample_file=${sample_file_names[$i]}
    echo "processing $sample_file"

    tophat2 --num-threads $threads --output-dir ${sample}_tophat2_out --b2-very-sensitive $ref_genome_prefix $sample_file

    mkdir ${sample}_cufflinks_out

    cufflinks --no-update-check --num-threads $threads --output-dir ${sample}_cufflinks_out --GTF $ref_gtf --mask-file $ref_mask_gtf \
      --multi-read-correct --frag-bias-correct $ref_genome --label $sample ${sample}_tophat2_out/accepted_hits.bam

    echo "${sample}_cufflinks_out/transcripts.gtf" >> assembly_GTF_list.txt

    i=$((i+1))
done

cuffmerge --num-threads $threads -o cuffmerge_output --ref-gtf $ref_gtf --ref-sequence $ref_genome assembly_GTF_list.txt > cuffmerge.log

cuffdiff --output-dir cuffdiff_output --frag-bias-correct $ref_genome --multi-read-correct \
  --mask-file $ref_mask_gtf --num-threads $threads cuffmerge_output/merged.gtf \
  ${sample_prefixes[0]}_tophat2_out/accepted_hits.bam,${sample_prefixes[1]}_tophat2_out/accepted_hits.bam \
  ${sample_prefixes[2]}_tophat2_out/accepted_hits.bam,${sample_prefixes[3]}_tophat2_out/accepted_hits.bam


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Bowtie2:
        Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.

    - TopHat:
        Trapnell C, Pachter L, Salzberg SL. TopHat: discovering splice junctions with RNA-Seq.
        Bioinformatics doi:10.1093/bioinformatics/btp120

        Langmead B, Trapnell C, Pop M, Salzberg SL. Ultrafast and memory-efficient alignment
        of short DNA sequences to the human genome. Genome Biology 10:R25.

        Kim D and Salzberg SL. TopHat-Fusion: an algorithm for discovery of novel fusion transcripts. Genome Biology 2011, 12:R72

        Kim D, Pertea G, Trapnell C, Pimentel H, Kelley R, Salzberg SL. TopHat2: accurate alignment
        of transcriptomes in the presence of insertions, deletions and gene fusions. . Genome Biology 2013, 14:R36

    - Cufflinks:
        doi:10.1038/nbt.1621
        doi:10.1186/gb-2011-12-3-r22
        doi:10.1093/bioinformatics/btr355
        doi:10.1038/nbt.2450
CITATION
