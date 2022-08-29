#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=snpeff           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load snpEff/4.3t-foss-2018b-Python-3.6.6-Java-1.8.0

<<README
    - snpEff manual: http://snpeff.sourceforge.net/SnpEff_manual.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
vcf_file='/scratch/data/bio/GCATemplates/e_coli/vcf/SRR10561103_freebayes_out.vcf'

######## PARAMETERS ########
sample='SRR10561103'
snpeff_database='ASM584v2'      # E. coli: GCF_000005845.2_ASM584v2

########## OUTPUTS #########
outfile="${sample}_snpeff.vcf"

################################### COMMANDS ###################################
# NOTE for bacterial genomes you may want to adjust the upstream/downstream option (-ud) default is 5000 bp
java -Xmx4g -jar $EBROOTSNPEFF/snpEff.jar ann -v $snpeff_database $vcf_file > $outfile

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: http://sc.tamu.edu/research/citation.php

    - snpEff:
        Cingolani P1, Platts A, Wang le L, Coon M, Nguyen T, Wang L, Land SJ, Lu X, Ruden DM.
        A program for annotating and predicting the effects of single nucleotide polymorphisms, SnpEff:
        SNPs in the genome of Drosophila melanogaster strain w1118; iso-2; iso-3.
        Fly (Austin). 2012 Apr-Jun;6(2):80-92. doi: 10.4161/fly.19695.
CITATION
