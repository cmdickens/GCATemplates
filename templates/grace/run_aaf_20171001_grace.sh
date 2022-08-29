#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=aaf              # job name
#SBATCH --time=00:01:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/8.3.0 OpenMPI/3.1.4 AAF/20171001-Python-2.7.16

<<README
    - AAF manual: https://github.com/fanhuan/AAF/blob/master/aafUserManual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
data_dir="$EBROOTAAF/data"

# example of data structure; each sample has its own directory within the default data directory
<<DATA_DIRECTORY_STRUCTURE
data
├── sp1
│   └── sp1.fa
├── sp10
│   └── sp10.fa
├── sp2
│   └── sp2.fa
└── sp3
    └── sp3.fa
DATA_DIRECTORY_STRUCTURE

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK
max_mem_gb=$SLURM_MEM_PER_NODE

########## OUTPUTS #########
tree_image='aaf_tree.png'

################################### COMMANDS ###################################
# uses default directory named data
aaf_phylokmer.py -t $threads -G $max_mem_gb -d $data_dir

aaf_distance.py -t $threads -G $max_mem_gb -i phylokmer.dat.gz -f phylokmer.wc

echo "library(ape)
tree<-read.tree('aaf.tre')
options(bitmapType='cairo')
png(file='$tree_image')
plot(tree, edge.width = 2, tip.color='blue')
dev.off()" > tree.R

Rscript tree.R


################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/wiki/index.php/HPRC:AckUs

    - AAF:
        Huan FanEmail author, Anthony R. Ives, Yann Surget-Groba and Charles H. Cannon
        An assembly and alignment-free method of phylogeny reconstruction from next-generation sequencing data.
        BMC Genomics 2015 16:522 DOI: 10.1186/s12864-015-1647-5
CITATION
