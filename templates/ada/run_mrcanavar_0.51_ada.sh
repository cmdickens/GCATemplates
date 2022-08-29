#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J mrcanavar              # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=4000]"     # reserves 4000MB memory per core
#BSUB -M 4000                   # sets to 4000MB process enforceable memory limit. (M * n)
#BSUB -W 2:10                   # sets to 2  hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load mrcanavar/0.51-GCCcore-6.3.0
module load SAMtools/1.3.1-GCCcore-6.3.0

<<README
    - mrCaNaVar manual: http://mrcanavar.sourceforge.net/manual.html
README

################################### VARIABLES ##################################
# if you don't already have a masked genome, mask genome with RepeatMasker, trf and RepeatScout
# The repeats should be masked with N characters in your genome. Lowercase letters will be treated as non-repeats. 
repeat_masked_genome='C_tropicalis_MYA-3404_chromosomes.fasta.masked.2.7.7.80.10.50.500.mask.masked'

# you need a bed file of genome gaps (Ns); use cmd_get_gap_coords_out_bed.pl in code4dna Ada module if needed
genome_gaps_bed_file='C_tropicalis_MYA-3404_chromosomes_gaps.bed'
sam_files_directory='DR12_sam_files'
sample_name='DR12'

################################### COMMANDS ###################################
# the --prep step only needs to be done once
mrcanavar --prep -fasta $repeat_masked_genome -gaps $genome_gaps_bed_file -conf config.cnvr

mkdir depth_files
mkdir out_cnv_calls

mrcanavar --read -conf config.cnvr -samdir $sam_files_directory -depth depth_files/read_out_$sample.depth
mrcanavar --call -conf config.cnvr -depth depth_files/read_out_$sample.depth -o out_cnv_calls/$sample

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - mrCaNaVar:
        Personalized copy number and segmental duplication maps using next-generation sequencing. Can Alkan,
        Jeffrey M. Kidd, Tomas Marques-Bonet, Gozde Aksay, Francesca Antonacci, Fereydoun Hormozdiari,
        Jacob O. Kitzman, Carl Baker, Maika Malig, Onur Mutlu, S. Cenk Sahinalp, Richard A. Gibbs, Evan E. Eichler.
        Nature Genetics, Oct, 41(10):1061-1067, 2009.
CITATION
