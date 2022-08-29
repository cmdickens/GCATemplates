#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=interproscan     # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=8           # CPUs (threads) per command
#SBATCH --mem=16G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load InterProScan/5.50-84.0-foss-2018b-Python-3.6.6

<<README
    - InterProScan manual: https://github.com/ebi-pf-team/interproscan/wiki/HowToRun
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
protein_fasta_file='/scratch/data/bio/GCATemplates/data/ips/erg_prot.fa'

######## PARAMETERS ########
# select one or more of the following; notice some are for bacteria only: SignalP
applications='CDD,Coils,Hamap,MobiDBLite,PIRSF,PRINTS,Pfam,ProSitePatterns,ProSiteProfiles,SMART,SUPERFAMILY,SignalP_EUK,TIGRFAM'

formats='TSV,XML,GFF3,HTML'         # comma separated list of output formats. Supported formats are TSV, XML, GFF3, HTML and SVG.

########## OUTPUTS #########
out_prefix='out_erg'

################################### COMMANDS ###################################

interproscan.sh --disable-precalc --tempdir $TMPDIR --input $protein_fasta_file --applications $applications --output-file-base $out_prefix --formats $formats

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - InterProScan:
            Jones, Philip. et al. Bioinformatics. 2014 May 1; 30(9): 1236–1240.
            Published online 2014 Jan 29. doi: 10.1093/bioinformatics/btu031
CITATION
