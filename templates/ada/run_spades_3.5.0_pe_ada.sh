#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J test_spades_pe         # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB (~1GB) the per process enforceable memory limit.
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SPAdes/3.5.0-goolf-1.7.20

<<README
    - SPAdes manual: http://spades.bioinf.spbau.ru/release3.5.0/manual.html

    estimated run time: ~45 minutes; max memory ~3.5Gb
        genome size 4.4Mb
        210,924 300bp read pairs
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# Using yaml format allows you to indicate orientation, and type of reads:
#   orientation: fr (forward reverse), rf (reverse forward), ff (forward forward)
#   type:   paired-end, mate-pairs, hq-mate-pairs, single
#           pacbio, nanopore, sanger, trusted-contigs, untrusted-contigs
# TODO Edit the names of your files in the appropriate lines below
echo "
[
  {
    orientation: 'fr',
    type: 'paired-end',
    left reads: [
      '../../data/sra/m_tuberculosis/ERR551611_pe_1.fastq.gz'
    ],
    right reads: [
      '../../data/sra/m_tuberculosis/ERR551611_pe_2.fastq.gz'
    ]
  }
]
" > $conf_file

######## PARAMETERS ########
threads=8               # make sure this is <= your BSUB -n value
max_memory=8            # max memory used in Gb, make sure this is less than the BSUB total job memory
kmers=81,85,91          # SPAdes will select the best build of the kmers you provide; must be odd number; max kmer=127
conf_file='conf.yaml'   # this will be created at runtime, we just need a name

########## OUTPUTS #########
output_dir='spades_out'

################################### COMMANDS ###################################
# command to run with defaults and the --cafeful option
spades.py --threads $threads --careful --dataset $conf_file --memory $max_memory -k $kmers -o $output_dir

#example of how to restart run from the mismatch correction step
#spades.py --threads $threads --careful --restart-from mc --memory $max_memory -k $kmers -o $output_dir

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SPAdes:
        Bankevich A., et al. SPAdes: A New Genome Assembly Algorithm and Its Applications to Single-Cell Sequencing.
        J Comput Biol. 2012 May; 19(5): 455–477. doi:  10.1089/cmb.2012.0021
CITATION
