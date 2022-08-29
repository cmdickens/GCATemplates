#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J l_rna_scaffolder       # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB per process enforceable memory limit. (M * n)
#BSUB -W 8:00                   # sets to 8 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load L_RNA_scaffolder/20151120-ictce-7.1.2
module load BioPerl/1.6.1-ictce-7.1.2-Perl-5.16.3
module load BLAT/3.5-intel-2015B

<<README
    - L_RNA_scaffolder manual: http://www.fishbrowser.org/software/L_RNA_scaffolder/index.php?action=isin&do=documentation
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
contigs='Chlre4_genomic_scaffolds.fasta'
blat_aln_file='chlre4_blat_aln.psl'
rna_seq_fasta='c_reinhardtii_rna_seq_SRR1179643_1.fasta'

######## PARAMETERS ########
frequency=2

########## OUTPUTS #########
output_dir='l_rna_out_chlre4'

################################### COMMANDS ###################################
# If your rna seqs are not in fastq format, convert fastq to fasta.
# If reads file is gzipped then use zcat if not gzipped then use cat
#zcat rna_seq.fastq | sed -n '1~4s/^@/>/p;2~4p' > rna_seq.fasta

# Generate .psl alignment file which is required by L_RNA_scaffolder.sh;
# You must use the -noHead option with blat
blat $contigs $rna_seq_fasta $blat_aln_file -noHead

mkdir $output_dir

L_RNA_scaffolder.sh -d $EBROOTL_RNA_SCAFFOLDER -i $blat_aln_file -j $contigs -f $frequency -o $output_dir

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - L_RNA_scaffolder:
        Xue W, Li JT, Zhu YP, Hou GY, Kong XF, Kuang YY, Sun XW. L_RNA_scaffolder: scaffolding genomes with transcripts.
        BMC Genomics. 2013 Sep 8;14(1):604.
CITATION
