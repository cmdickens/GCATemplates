#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J tophat2                # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB (~2.5GB) the per process enforceable memory limit.
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load TopHat/2.1.1-intel-2015B
module load Bowtie2/2.2.9-intel-2015B

<<README
    - TopHat manual:
        https://ccb.jhu.edu/software/tophat/manual.shtml

    - Bowtie2 manual:
        http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
se_1='../../../../data/sra/e_coli/ecoli_transcriptome_rna_seq_SRR933983_1.fastq.gz'
genome_fasta='../../../../data/sra/e_coli/CP000948.fna'

######## PARAMETERS ########
threads=4                       # make sure this is <= your BSUB -n value

########## OUTPUTS #########
genome_prefix='CP000948'        # note how the genome_prefix relates to the genome_fasta name

################################### COMMANDS ###################################
# create bowtie2 genome index (only needs to be done once, if you rerun the script comment out next line)
bowtie2-build $genome_fasta $genome_prefix

tophat2 --num-threads $threads $genome_prefix $se_1


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - TopHat2 citation:
        Kim D, Pertea G, Trapnell C, Pimentel H, Kelley R, Salzberg SL. TopHat2: 
        accurate alignment of transcriptomes in the presence of insertions, deletions and gene fusions.
        Genome Biology 2013, 14:R36.

    - Bowtie2 citation:
        Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.
CITATION
