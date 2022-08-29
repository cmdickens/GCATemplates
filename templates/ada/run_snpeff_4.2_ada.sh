#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J snpeff                 # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load snpEff/4.2-Java-1.7.0_80

<<README
    - snpEff manual: http://snpeff.sourceforge.net/SnpEff_manual.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
vcf_file='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/dr34.vcf'

# to see available snpEff databases: java -jar $EBROOTSNPEFF/snpEff.jar databases > db_snpeff.txt
snpeff_database='GCA_000026945.1.29'        # Candida_dubliniensis_cd36

######## PARAMETERS ########
sample='dr34'

########## OUTPUTS #########
outfile="${sample}_snpeff_ann.vcf"

################################### COMMANDS ###################################
# NOTE for bacterial genomes you may want to adjust the upstream/downstream option (-ud) default is 5000 bp
#      or use the options -no-upstream -no-downstream -no-intergenic
java -Xmx4g -jar $EBROOTSNPEFF/snpEff.jar ann -v $snpeff_database $vcf_file > $outfile

<<CITATION
    - Acknowledge TAMU HPRC: http://sc.tamu.edu/research/citation.php

    - snpEff:
        Cingolani P1, Platts A, Wang le L, Coon M, Nguyen T, Wang L, Land SJ, Lu X, Ruden DM.
        A program for annotating and predicting the effects of single nucleotide polymorphisms, SnpEff:
        SNPs in the genome of Drosophila melanogaster strain w1118; iso-2; iso-3.
        Fly (Austin). 2012 Apr-Jun;6(2):80-92. doi: 10.4161/fly.19695.
CITATION
