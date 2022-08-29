#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J interproscan           # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=2000]"     # reserves 2000MB memory per core
#BSUB -M 2000                   # sets to 2000MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load InterProScan/5.40-77.0-foss-2018b-Python-3.6.6

<<README
    - InterProScan manual: https://github.com/ebi-pf-team/interproscan/wiki/HowToRun
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
protein_fasta_file='/scratch/datasets/GCATemplates/data/ips/erg_prot.fa'

######## PARAMETERS ########
# select one or more of the following; notice some are for bacteria only: SignalP
applications='TIGRFAM,PIRSF,ProDom,SMART,PrositeProfiles,PrositePatterns,HAMAP,PfamA,PRINTS,SuperFamily,Coils,SignalP-GRAM_POSITIVE,SignalP-GRAM_NEGATIVE,SignalP-EUK,Phobius,TMHMM'

formats='TSV,XML,GFF3'        # comma separated list of output formats. Supported formats are TSV, XML, GFF3, HTML and SVG.

########## OUTPUTS #########
out_prefix='out_erg'

################################### COMMANDS ###################################
#
interproscan.sh --disable-precalc --tempdir $TMPDIR --input $protein_fasta_file --applications $applications --output-file-base $out_prefix --formats $formats

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - InterProScan:
            Jones, Philip. et al. Bioinformatics. 2014 May 1; 30(9): 1236–1240.
            Published online 2014 Jan 29. doi: 10.1093/bioinformatics/btu031
CITATION
