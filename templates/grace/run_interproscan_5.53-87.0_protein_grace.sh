#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=ips-5.53-87.0    # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=12          # CPUs (threads) per command
#SBATCH --mem=90G                   # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/9.3.0  OpenMPI/4.0.3  InterProScan/5.53-87.0-Python-3.8.2
module load WebProxy

<<README
    - InterProScan manual: https://github.com/ebi-pf-team/interproscan/wiki/HowToRun
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
protein_fasta_file='/scratch/data/bio/GCATemplates/data/ips/erg_prot.fa'

######## PARAMETERS ########
# select one or more of the following; notice some are for bacteria only: SignalP. The ProDom application is deprecated
applications='TIGRFAM,PIRSF,SMART,PrositeProfiles,PrositePatterns,HAMAP,Phobius,PfamA,PRINTS,SuperFamily,Coils,SignalP-GRAM_POSITIVE,SignalP-GRAM_NEGATIVE,SignalP-EUK,TMHMM,PANTHER'

# supported formats are JSON, TSV, XML and GFF3. The HTML and SVG formats are deprecated
formats='JSON,TSV,XML,GFF3'

########## OUTPUTS #########
out_dir="out_ips_$EBVERSIONINTERPROSCAN"

################################### COMMANDS ###################################
[ -d $out_dir ] || mkdir $out_dir

interproscan.sh --tempdir $TMPDIR --cpu $SLURM_CPUS_PER_TASK --input $protein_fasta_file \
  --applications $applications  --formats $formats  --output-dir $out_dir

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - InterProScan:
            Jones, Philip. et al. Bioinformatics. 2014 May 1; 30(9): 1236–1240.
            Published online 2014 Jan 29. doi: 10.1093/bioinformatics/btu031
CITATION
