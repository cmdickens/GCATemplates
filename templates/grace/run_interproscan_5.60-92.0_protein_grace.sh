#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=ips-5.60-92.0    # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=8           # CPUs (threads) per command
#SBATCH --mem=60G                   # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load  GCC/11.2.0  OpenMPI/4.1.1 InterProScan/5.60-92.0
module load WebProxy

<<README
    - InterProScan manual: https://github.com/ebi-pf-team/interproscan/wiki/HowToRun
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
protein_fasta_file='/scratch/data/bio/GCATemplates/data/ips/erg_prot.fa'

######## PARAMETERS ########
# select one or more of the following; notice some are for bacteria only: SignalP.
applications='TIGRFAM,FunFam,SFLD,Phobius,SignalP_GRAM_NEGATIVE,PANTHER,Gene3D,Hamap,PRINTS,ProSiteProfiles,Coils,SUPERFAMILY,SMART,CDD,PIRSR,ProSitePatterns,AntiFam,SignalP_EUK,Pfam,MobiDBLite,SignalP_GRAM_POSITIVE,PIRSF,TMHMM'

# supported formats are JSON, TSV, XML and GFF3. The HTML and SVG formats are deprecated
formats='JSON,TSV,XML,GFF3'

########## OUTPUTS #########
out_dir="out_ips_$EBVERSIONINTERPROSCAN"

################################### COMMANDS ###################################
[ -d $out_dir ] || mkdir $out_dir

interproscan.sh --tempdir $TMPDIR --cpu $SLURM_CPUS_PER_TASK --input $protein_fasta_file \
  --applications $applications  --formats $formats  --output-dir $out_dir --disable-precalc

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - InterProScan:
            Jones, Philip. et al. Bioinformatics. 2014 May 1; 30(9): 1236–1240.
            Published online 2014 Jan 29. doi: 10.1093/bioinformatics/btu031
CITATION
