#BSUB -L /bin/bash              # uses the bash login shell for the job's execution environment.
#BSUB -J circlator              # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=12300]"    # reserves 12300MB memory per core
#BSUB -M 12300                  # sets to 12300MB per process enforceable memory limit. (M * n)
#BSUB -R "select[mem256gb]"     # select 256GB memory node
#BSUB -W 48:00                  # sets to 48 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Circlator/1.5.5-intel-2017A-Python-3.5.2

<<README
    - Circlator manual: https://github.com/sanger-pathogens/circlator/wiki
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
assembly_fasta='/scratch/datasets/GCATemplates/data/pacbio/OR74A_canu_build/n_crassa_256.contigs.fasta'
reads_fastq='/scratch/datasets/GCATemplates/data/pacbio/OR74A_filtered_subreads.fastq'

######## PARAMETERS ########
threads=20

########## OUTPUTS #########
outdir='circlator_out'

################################### COMMANDS ###################################
# 
circlator all --threads $threads $assembly_fasta $reads_fastq $outdir

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Circlator:
        Circlator: automated circularization of genome assemblies using long sequencing reads
        Hunt et al, Genome Biology 2015 Dec 29;16(1):294. doi: 10.1186/s13059-015-0849-0

    - BWA:
        Li, H et al. Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv:1303.3997.

    - MUMmer:
        Kurtz, S. et al. Versatile and open software for comparing large genomes. Genome Biol. 5, R12 (2004).

    - Prodigal:
        Hyatt, D. et al. Prodigal: prokaryotic gene recognition and translation initiation site identification.
        BMC Bioinformatics 11, 119 (2010).

    - SAMtools:
        Li, H. et al. The Sequence Alignment/Map format and SAMtools. Bioinformatics 25, 2078–9 (2009).

    - SPAdes:
        Bankevich, A. et al. SPAdes: a new genome assembly algorithm and its applications to single-cell sequencing.
        J. Comput. Biol. 19, 455–77 (2012)
CITATION
