#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J redundans              # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Redundans/0.13c-intel-2017b-Python-2.7.14

<<README
    - Redundans manual: https://github.com/Gabaldonlab/redundans
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
cp -r $EBROOTREDUNDANS/test/ ./ && chmod 755 test/      # only needed for test data example
assembly_contigs='test/contigs.fa'
pe_mp_reads='test/*_?.fq.gz'
nanopore_reads='test/nanopore.fa.gz'
pacbio_reads='test/pacbio.fq.gz'

######## PARAMETERS ########
threads=20

########## OUTPUTS #########
out_dir='run_short_long'

################################### COMMANDS ###################################
# reduction, scaffolding with paired-end, mate pairs and long reads, and gap closing with paired-end and mate pairs
redundans.py -v -t $threads -i $pe_mp_reads -l $pacbio_reads $nanopore_reads -f $assembly_contigs -o $out_dir

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Redundans:
        Leszek P. Pryszcz and Toni Gabaldón (2016) Redundans: an assembly pipeline
        for highly heterozygous genomes. NAR. doi: 10.1093/nar/gkw294
CITATION
