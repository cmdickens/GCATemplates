#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J aaf                    # job name
#BSUB -n 20                     # assigns 4 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 4 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 4 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load AAF/20171001-intel-2017A-Python-2.7.12

<<README
    - AAF manual: https://github.com/fanhuan/AAF/blob/master/aafUserManual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# example of data structure; each sample has its own directory within the default data directory
<<DATA_DIRECTORY_STRUCTURE
data/
|-- sp1
|   '-- sp1.fa
|-- sp10
|   '-- sp10.fa
'-- sp2
    '-- sp2.fa
DATA_DIRECTORY_STRUCTURE

######## PARAMETERS ########
threads=20                      # make sure this is <= your BSUB -n value

max_mem=50                      # 50 GB
kmer=21                         # kmer length, default = 25
datadir="$EBROOTAAF/data"

########## OUTPUTS #########
output_tree='aaf_tree.png'

################################### COMMANDS ###################################
#
aaf_phylokmer.py -t $threads -G $max_mem -k $kmer -k $kmer -d $datadir

aaf_distance.py -t $threads -G $max_mem -i phylokmer.dat.gz -f phylokmer.wc

echo "library(ape)
tree<-read.tree('aaf.tre')
options(bitmapType='cairo')
png(file='$output_tree')
plot(tree, edge.width = 2, tip.color='blue')
dev.off()" > tree.R

Rscript tree.R

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - AAF:
        Huan FanEmail author, Anthony R. Ives, Yann Surget-Groba and Charles H. Cannon
        An assembly and alignment-free method of phylogeny reconstruction from next-generation sequencing data.
        BMC Genomics 2015 16:522 DOI: 10.1186/s12864-015-1647-5
CITATION
