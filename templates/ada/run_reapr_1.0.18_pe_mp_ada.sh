#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J reapr                  # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

#module load Westmere            # load this only if using BSUB -q xlarge
module load REAPR/1.0.18-intel-2015B-Perl-5.20.0

<<README
    - REAPR manual: ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.18.manual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
assembly_pe_mp='../testing_sspace_bowtie/test_sspace/test_sspace.final.scaffolds.fasta'

# short reads can be zipped
pe_1='../../../data/sra/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe_2='../../../data/sra/m_tuberculosis/ERR551611_pe_2.fastq.gz'

# long reads must be unzipped
mp2kb_1='../testing_reapr/ERR760550_mp2kb_1.fastq'
mp2kb_2='../testing_reapr/ERR760550_mp2kb_2.fastq'

######## PARAMETERS ########
threads=8                       # make sure this is <= your BSUB -n value
fachecked_build="build_contigs_renamed"   #reapr will append .fa to this prefix

########## OUTPUTS #########
outdir='out_reapr_pe_mp'

################################### COMMANDS ###################################
# TODO: first run only this command to validate contig names
reapr facheck $assembly_pe_mp

# if the facheck command returns errors then rename contigs using the next two commands
reapr facheck $assembly_pe_mp $fachecked_build
assembly_pe_mp=${fachecked_build}.fa

################################################################################
# SMALL GENOMES: use this section for small genomes only containing short and long insert libraries
# omit the next two commands if you are not using perfect unique mapping information
reapr perfectmap $assembly_pe_mp $pe_1 $pe_2 400 perfect_prefix
reapr smaltmap -n $threads $assembly_pe_mp $mp2kb_1 $mp2kb_2 long_mapped.bam
reapr pipeline $assembly_pe_mp long_mapped.bam $outdir perfect_prefix


################################################################################
# LARGE GENOMES: use this section for large genomes only containing short and long insert libraries
#reapr smaltmap -n $threads $assembly_pe_mp $pe_1 $pe_2 short_mapped.bam
#reapr perfectfrombam short_mapped.bam perfect 100 500 3 4 76
#reapr smaltmap $assembly_pe_mp $mp2kb_1 $mp2kb_2 long_mapped.bam
#reapr pipeline $assembly_pe_mp long_mapped.bam $outdir perfect_prefix

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - REAPR:
        Martin Hunt, Taisei Kikuchi, Mandy Sanders, Chris Newbold, Matthew Berriman and Thomas D Otto.
        REAPR: a universal tool for genome assembly evaluation. Genome Biology 2013, 14:R47.
        doi:10.1186/gb-2013-14-5-r47. 
CITATION
