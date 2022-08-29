#BSUB -L /bin/bash
#BSUB -J orthomcl_2.0.9
#BSUB -o stdout.%J
#BSUB -e stderr.%J
#BSUB -n 20
#BSUB -R "span[ptile=20]"
#BSUB -R "rusage[mem=2700]"
#BSUB -M 2700
#BSUB -W 1:00

<<RUN_ON_LOGIN_NODE_PRIOR_TO_RUNNING_JOB
# run the following 2 commands only once in your working dirctory before you run your job script
module purge
/software/hprc/Bio/OrthoMCL/setup_mysql.sh
# type any key except 'y' when prompted and use the following location (full path)
# Type your new location: /scratch/user/<NetID>/orthomcl_mysql
# this creates the orthomcl.config file used in step (9)
RUN_ON_LOGIN_NODE_PRIOR_TO_RUNNING_JOB

<<README
    - OrthoMCL UserGuide: http://orthomcl.org/common/downloads/software/v2.0/UserGuide.txt
README

module load OrthoMCL/2.0.9-intel-2015B-Perl-5.20.0

# NOTE see UserGuide for specific details on the following steps which are numbered to conincide with the UserGuide
# steps (5) - (8) do not require MySQL; steps (9) - (13) require starting MySQL
################################### VARIABLES ##################################
# TODO Edit these variables as needed, currently they are a test data set of 3 species
# step (5)
# Create an OrthoMCL compliant .fasta file, by adjusting definition lines.
mkdir -p my_orthomcl_dir/compliantFasta
cd my_orthomcl_dir/compliantFasta
orthomclAdjustFasta cal /scratch/datasets/GCATemplates/data/orthomcl/cal_orthologs.fa 1
orthomclAdjustFasta cdu /scratch/datasets/GCATemplates/data/orthomcl/cdu_orthologs.fa 1
orthomclAdjustFasta cgr /scratch/datasets/GCATemplates/data/orthomcl/cgr_orthologs.fa 1
cd ../..

################################### COMMANDS ###################################
# step (6)
# output will create the goodProteins.fasta file to use in step 7
orthomclFilterFasta my_orthomcl_dir/compliantFasta 10 20

################################################################################
# step (7)
# run all-vs-all "BLAST -m 8" on goodProteins.fasta
formatdb -i goodProteins.fasta -t goodProteins.fasta -p T
dbsize=`grep -v ">" goodProteins.fasta | wc | awk '{print $3-$1}'`
blastall -p blastp -i goodProteins.fasta -d goodProteins.fasta -m 8 -e 1e-5 -F 'm S' -v 100000 -b 100000 -z $dbsize > all_vs_all_goodProteins_m8.out

################################################################################
# step (8)
# run orthomclBlastParser on the NCBI BLAST tab output to create a file of similarities in the required format
orthomclBlastParser all_vs_all_goodProteins_m8.out my_orthomcl_dir/compliantFasta > my_orthomcl_dir/SimilarSequences.txt

################################################################################
# start mysql for steps (9) - (13); notice you must do module purge before starting mysql
module purge
./mysqld start &
if [ "$?" != 0 ]; then
    echo "mysqld process failed to start. exiting"
    exit 1
fi
module load OrthoMCL/2.0.9-intel-2015B-Perl-5.20.0

################################################################################
# step (9)
echo "RUNNING orthomclLoadBlast" 1>&2
orthomclLoadBlast orthomcl.config my_orthomcl_dir/SimilarSequences.txt

################################################################################
# step (10)
echo "RUNNING orthomclPairs" 1>&2
orthomclPairs orthomcl.config my_orthomcl_dir/orthomclPairs.log cleanup=yes

################################################################################
#step (11)
echo "RUNNING orthomclDumpPairsFiles" 1>&2
orthomclDumpPairsFiles orthomcl.config

################################################################################
#step (12)
echo "RUNNING mclInput" 1>&2
mcl mclInput --abc -I 1.5 -o mclOutput

################################################################################
#step (13)
echo "RUNNING orthomclMclToGroups" 1>&2
orthomclMclToGroups my_mclgroups 1000 < mclOutput > groups.txt

################################################################################
# stop mysql
module purge
./mysqld stop


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - OrthoMCL:
        Feng Chen, Aaron J. Mackey, Christian J. Stoeckert, Jr., and David S. Roos
        OrthoMCL-DB: querying a comprehensive multi-species collection of ortholog groups
        Nucleic Acids Res. 2006 34: D363-8.
CITATION
