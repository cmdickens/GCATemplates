#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J pasa                   # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load PASA/2.3.3-foss-2018b-Perl-5.28.0

<<README
    - PASA manual: https://github.com/PASApipeline/PASApipeline/wiki
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
fasta_reference='/scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/C_dubliniensis_CD36.fasta'

# the next line is for test data only; delete the next line when running with your data
ln -s /scratch/datasets/GCATemplates/data/miseq/c_dubliniensis/Trinity.fasta test_Trinity.fasta
transcripts_file='test_Trinity.fasta'

######## PARAMETERS ########
# if you don't want to use the UniVec_Core vector file, then remove the -v part of the seqclean command below
vector_file='/scratch/datasets/kraken2/curie/invertebrates_standard/library/UniVec_Core/UniVec_Core'
threads=20
aligners='blat,gmap'            # 'blat', 'gmap' or both 'blat,gmap'
min_percent_aligned=80
min_avg_per_id=80

########## OUTPUTS #########
sqlite_db=$(pwd)/pasadb

# create config file
echo "
# database settings
DATABASE=$sqlite_db

#script validate_alignments_in_db.dbi
validate_alignments_in_db.dbi:--MIN_PERCENT_ALIGNED=$min_percent_aligned
validate_alignments_in_db.dbi:--MIN_AVG_PER_ID=$min_avg_per_id

#script subcluster_builder.dbi
subcluster_builder.dbi:-m=50" > alignAssembly.config

################################### COMMANDS ###################################
# clean transcripts file including UniVec_Core seqs
$PASAHOME/bin/seqclean $transcripts_file -v $vector_file

# run PASA pipeline
$PASAHOME/Launch_PASA_pipeline.pl \
           -c alignAssembly.config -C -R -g $fasta_reference \
           -t ${transcripts_file}.clean -T -u $transcripts_file \
           --ALIGNERS $aligners --CPU $threads

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - PASA:
        Haas, B.J., Delcher, A.L., Mount, S.M., Wortman, J.R., Smith Jr, R.K., Jr., Hannick, L.I.,
        Maiti, R., Ronning, C.M., Rusch, D.B., Town, C.D. et al. (2003) Improving the Arabidopsis genome
        annotation using maximal transcript alignment assemblies. Nucleic Acids Res, 31, 5654-5666.
CITATION
