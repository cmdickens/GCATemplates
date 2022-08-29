#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J aaf                    # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load AAF/20160518-intel-2015B

<<README
    - AAF homepage: https://sourceforge.net/projects/aaf-phylogeny/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# example of data structure; each sample has its own directory within the default data directory
<<DATA_DIRECTORY_STRUCTURE
data/
 |-- dr31
 |   '-- DR31_S1_L001_R1_001.fastq.gz
 |-- dr32
 |   '-- DR32_S2_L001_R1_001.fastq.gz
 |-- dr33
 |   '-- DR33_S3_L001_R1_001.fastq.gz
 |-- dr34
     '-- DR34_S4_L001_R1_001.fastq.gz
DATA_DIRECTORY_STRUCTURE

######## PARAMETERS ########
threads=5                       # make sure this is <= your BSUB -n value
max_mem=10                      # 10 GB

########## OUTPUTS #########
output_tree='aaf_tree.png'

################################### COMMANDS ###################################
#
aaf_phylokmer.py -t $threads -G $max_mem

aaf_distance.py -t $threads -G $max_mem

echo "library(ape)
tree<-read.tree('aaf.tre')
options(bitmapType='cairo')
png(file='$output_tree')
plot(tree, edge.width = 2, tip.color='blue')
dev.off()" > tree.R

Rscript tree.R

<<CITATION
    - Acknowledge TAMU HPRC: http://sc.tamu.edu/research/citation.php

    - AAF:
        Huan FanEmail author, Anthony R. Ives, Yann Surget-Groba and Charles H. Cannon
        An assembly and alignment-free method of phylogeny reconstruction from next-generation sequencing data.
        BMC Genomics 2015 16:522 DOI: 10.1186/s12864-015-1647-5
CITATION
