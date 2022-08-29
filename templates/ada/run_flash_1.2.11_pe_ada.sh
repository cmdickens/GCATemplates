#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J flash                  # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load FLASH/1.2.11

<<README
    - FLASH (Fast Length Adjustment of SHort reads) is a very fast and accurate software tool to merge paired-end reads.
    - FLASH manual: http://ccb.jhu.edu/software/FLASH/MANUAL
    - FLASH homepage: http://ccb.jhu.edu/software/FLASH/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
pe_1='../../../data/sra/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe_2='../../../data/sra/m_tuberculosis/ERR551611_pe_2.fastq.gz'

######## PARAMETERS ########
threads=8                       # make sure this is <= your BSUB -n value
min_overlap=10                  # default 10
max_overlap=65                  # default 65

avg_read_length=250             # default 100
avg_frag_length=400             # default 180
stdev_frag_length=50            # default 20

########## OUTPUTS #########
output_prefix="ERR551611"

################################### COMMANDS ###################################
# command with gzip output (-z)
flash -z -m $min_overlap -t $threads -r $avg_read_length -f $avg_frag_length -s $stdev_frag_length -o $output_prefix $pe_1 $pe_2

<<NOTE
    Don't use -M in conjunction with -r -f -s in the same command.
    Using all four together will result in all four being set to default values
        [FLASH] WARNING: --read-len (-r) has no effect when --max-overlap (-M) is also specified!
        [FLASH] WARNING: --fragment-len (-f) has no effect when --max-overlap (-M) is also specified!
        [FLASH] WARNING: --fragment-len-stddev (-s) has no effect when --max-overlap (-M) is also specified!
NOTE

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - FLASH:
        FLASH: Fast length adjustment of short reads to improve genome assemblies. T. Magoc and S. Salzberg.
        Bioinformatics 27:21 (2011), 2957-63.
CITATION

<<USAGE
flash <mates1.fastq> <mates2.fastq> [-m minOverlap] [-M maxOverlap] [-x mismatchRatio] 
[-p phredOffset] [-o prefixOfOutputFiles] [-d pathToDirectoryForOutputFiles] 
[-f averageFragment Length] [-s standardDeviationOfFragments] [-r averageReadLength]
[-h displayHelp] 

mates1.fastq and mates2.fastq are fastq files of paired-end reads from the short 
fragment library (with insert size less than twice the length of reads). The 
corresponding mates should be in the same order in both files.


Options:

-m: minOverlap is the minimum required overlap length between two reads to provide 
a confident overlap. Default: 10bp.

-M: maxOverlap is the maximum overlap length expected in approximately 90% of read 
pairs. It is by default set to 70bp, which works well for 100bp reads generated from 
180bp library (normal distribution of fragment lengths is assumed). Overlaps longer 
than maxOverlap are still considered as good overlaps, but the mismatch ratio 
(explained below) is calculated over the maxOverlap rather than the true overlap 
length. If you enter a value for maxOverlap, then the read length, fragmetn length 
and standard deviaiton of fragment lengths that you enter will be ignored for 
calculation of maxOverlap parameter. Default: 70bp.

-x: mismatchRatio is the maximum allowed ratio of the number of mismatches and the 
overlap length. An overlap with mismatch ratio higher than the set value is considered 
incorrect overlap and mates will not be merged. Any occurence of an "N" in any read is 
ignored and not counted towards the mismatches or overlap length. Our experimental 
results suggest that higher values of mismatchRatio yield larger number of correctly 
merged read pairs but at the expense of higher number of incorrectly merged read 
pairs. Default: 0.25. 

-p: phredOffset is the smallest ASCII value of the characters used to represent 
quality values of bases in fastq files. It should be set to either 33, which corresponds 
to the later Illumina platforms and Sanger platforms, or 64, which corresponds to 
the earlier Illumina platforms. Default: 33.

-o: prefix of output files. Default: out.

-d: path to directory for the output files. Default: current working directory.

-r: average read length. Default: 100.

-f: average fragment length. Default: 180.

-s: standard deviation of fragment lengths. If you do not know standard deviation of the 
fragment library, you can probably assume that the standard deviation is 10% of the average 
fragment length. Default: 20. 

-h: display help information.
USAGE
