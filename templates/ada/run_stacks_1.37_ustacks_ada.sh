#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J stacks                 # job name
#BSUB -n 1                      # assigns 1 core(s) for execution
#BSUB -R "span[ptile=1]"        # assigns 1 core(s) per node
#BSUB -R "rusage[mem=10]"       # reserves 10MB memory per core
#BSUB -M 10                     # sets to 10MB process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Stacks/1.37-intel-2015B

<<README
    - Stacks homepage: http://catchenlab.life.illinois.edu/stacks/
    - Stacks manual: http://catchenlab.life.illinois.edu/stacks/manual/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
threads=1                       # make sure this is <= your BSUB -n value

input_file="female.fa"

sample_index=2

output_dir='stacks_out'

################################### COMMANDS ###################################
#
mkdir $output_dir
ustacks -t fasta -p $threads -f $input_file -o $output_dir -i $sample_index -R


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Stacks:
        Julian M. Catchen, Angel Amores, Paul Hohenlohe, William Cresko, and John H. Postlethwait†,
        Stacks: Building and Genotyping Loci De Novo From Short-Read Sequences
        G3 (Bethesda). 2011 Aug; 1(3): 171–182.  doi:  10.1534/g3.111.000240
CITATION
