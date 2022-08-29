#BSUB -L /bin/bash              # uses the bash login for the job's execution environment.
#BSUB -J pbjelly                # job name
#BSUB -n 20                     # assigns 20 cores for the job
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB (~2.7GB) per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load PBSuite/15.8.24-intel-2017A-Python-2.7.12

<<README
    - PBJelly manual: https://sourceforge.net/p/pb-jelly/wiki/Home/?#058c
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# References must end with .fasta
# copy the sample reference data directory to your directory to run the test data
#   cp -r /scratch/datasets/GCATemplates/data/pbjelly/reference/ ./
reference_fasta="$PWD/reference/lambda.fasta"
# no need to copy the reads directory to run the test data
reads_based_directory='/scratch/datasets/GCATemplates/data/pbjelly/reads/'     # directory containing your subreads.fastq files

######## PARAMETERS ########
# blasr is a slow step so use plenty of walltime but it could cost many SUs based on num_subjobs value
num_subjobs=4               # one subjob per subreads.fastq sequence file is good but can set higher for the assembly stage
subjob_cores=20             # number of cores to use for subjobs including each blasr alignment
subjob_time='24:00'         # walltime to use for subjobs including each blasr alignment
subjob_mem_per_core=2700    # memory per core to use for subjobs including each blasr alignment

########## OUTPUTS #########
output_dir="$PWD/pbjelly_out/"

# no need to rename this since the protocol_xml file is automatically created in the section below
protocol_xml='TemplateProtocolCluster.xml'

# edit the following xml tag values in the section below
#   <blasr>     # edit blasr options as needed
#   <job>       # each job line is a subreads.fastq file (.fastq or .fasta only)
tee $protocol_xml << XML_FILE
<jellyProtocol>
    <reference>$reference_fasta</reference>
    <outputDir>$output_dir</outputDir>
    <cluster>
        <command>echo '\${CMD}' | bsub -J \${JOBNAME} -W $subjob_time -o \${STDOUT} -e \${STDERR} -n $subjob_cores -L /bin/bash -M $subjob_mem_per_core -R span[ptile=$subjob_cores]</command>
        <nJobs>$num_subjobs</nJobs>
    </cluster>
    <blasr>--minMatch 8 --sdpTupleSize 8 --minPctSimilarity 75 --bestn 1 --nCandidates 10 --maxScore -500 --nproc $subjob_cores --noSplitSubreads</blasr>
    <input baseDir='$reads_based_directory'>
        <job>filtered_subreads.fastq</job>
        <job>filtered_subreads_2.fastq</job>
    </input>
</jellyProtocol>
XML_FILE

################################### COMMANDS ###################################
# make output directory if it does not exist
[ -d $output_dir ] || mkdir $output_dir

# Wait until each stage completes including all its subjobs before submitting the job for the next stage
Jelly.py setup $protocol_xml

#Jelly.py mapping $protocol_xml

#Jelly.py support $protocol_xml

#Jelly.py extraction $protocol_xml

#Jelly.py assembly $protocol_xml

#Jelly.py output $protocol_xml

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - PBSuite citation:
            English, Adam C., Stephen Richards, Yi Han, Min Wang,
            Vanesa Vee, Jiaxin Qu, Xiang Qin, et al. "Mind the
            Gap: Upgrading Genomes with Pacific Biosciences RS
            Long-Read Sequencing Technology." PLoS ONE 7, no. 11
            (November 21, 2012): e47768. doi:10.1371/journal.pone.0047768.
CITATION
