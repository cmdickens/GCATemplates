#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J sailfish               # job name
#BSUB -n 10                     # assigns 20 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                  # sets to 48 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Sailfish/0.9.0

<<'README'
    - Sailfish manual: http://sailfish.readthedocs.io/en/master/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
# bam file of your reads aligned to the reference
index_dir='index_sailfish_SRR575493'
quant_dir='quant_sailfish_SRR575493'
ref_seqs='/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_rna-seq_assembly_SRR575493_Trinity.fasta'
se_reads='/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_rna-seq_reads_SRR575493.fastq'

threads=10

################################### COMMANDS ###################################
# command to run with defaults
sailfish index -t $ref_seqs -o $index_dir -k 31 -p $threads
sailfish quant -i $index_dir -l U -r $se_reads -o $quant_dir -p $threads

<<'CITATION'
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Sailfish citation:
        Rob Patro, Stephen M. Mount, and Carl Kingsford (2014) Sailfish enables alignment-free isoform quantification
        from RNA-seq reads using lightweight algorithms. Nature Biotechnology (doi:10.1038/nbt.2862)
CITATION
