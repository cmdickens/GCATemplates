#BSUB -L /bin/bash              # uses the bash login shell for the job's execution environment.
#BSUB -J canu_grid              # job name
#BSUB -n 16                     # assigns 16 cores for execution
#BSUB -R "span[ptile=16]"       # assigns 16 cores per node
#BSUB -R "rusage[mem=15000]"    # reserves 15000MB memory per core
#BSUB -M 15000                  # sets to 15000MB per process enforceable memory limit. (M * n)
#BSUB -W 8:00                   # sets to 8 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module='Canu/1.7.1-foss-2017A-Perl-5.24.0-ppc64'
module load $module

<<'README'
    - Canu Tutorial: http://canu.readthedocs.io/en/latest/tutorial.html
README

################################################################################
# TODO Edit these variables as needed:
pacbio_raw_reads="/scratch/datasets/GCATemplates/data/pacbio/OR74A_filtered_subreads.fastq"
genome_size='40m'               # supported units: g, m, k
prefix="OR74A"                  # this will be appended to job name for multi-node grid submission
assembly_directory="canu_grid_out"

################################################################################
# command to run pipeline with -pacbio-raw option for subreads files
canu useGrid=true gridOptions="-L /bin/bash -W 168:00 -R 'rusage[mem=15000]' -M 15000" \
preExec="module load $module" java=$EBROOTJAVA/bin/java \
gnuplot=$EBROOTGNUPLOT/bin/gnuplot gnuplotImageFormat=png \
-p $prefix -d $assembly_directory genomeSize=$genome_size \
-pacbio-raw $pacbio_raw_reads minThreads=16 maxThreads=16 minMemory=220 maxMemory=240

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Canu: Koren S, Walenz BP, Berlin K, Miller JR, Phillippy AM.
            Canu: scalable and accurate long-read assembly via adaptive
            k-mer weighting and repeat separation. Genome Research. (2017).
CITATION
