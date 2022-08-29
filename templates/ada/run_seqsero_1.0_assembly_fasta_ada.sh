#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J seqsero                # job name
#BSUB -n 1                      # assigns 1 core for execution
#BSUB -R "span[ptile=1]"        # assigns 1 core per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SeqSero/f3bd721-intel-2015B-Python-2.7.10

<<README
    SeqSero Homepage: https://github.com/denglab/SeqSero/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
assembly='/scratch/datasets/GCATemplates/data/sra/s_enteritidis/spades_out/scaffolds.fasta'

################################### COMMANDS ###################################
# run on assembly fasta file
SeqSero.py -m 4 -i $assembly

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SeqSero:
        Zhang S, Yin Y, Jones MB, Zhang Z, Deatherage Kaiser BL, Dinsmore BA, Fitzgerald C, Fields PI, Deng X.
        Salmonella serotype determination utilizing high-throughput genome sequencing data.
        J Clin Microbiol. 2015 May;53(5):1685-92.PMID:25762776
CITATION
