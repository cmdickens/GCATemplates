#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J structure              # job name
#BSUB -n 1                      # assigns 1 cores for execution
#BSUB -R "span[ptile=1]"        # assigns 1 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Structure/2.3.4

<<README
    - Structure manual: 
https://web.stanford.edu/group/pritchardlab/structure_software/release_versions/v2.3.4/structure_doc.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
# copy the mainparams, extraparams and testdata1 to current directory
# comment out the next line after you have copied all files and are ready to run with your data
cp $EBROOTSTRUCTURE/{mainparams,extraparams,testdata1} ./

input_file='testdata1'          # -i
output_file='output_testdata1'  # -o
# edit the following to match your population (current settings are for testdata1)
num_populations=2               # -K
num_loci=6                      # -L
num_individuals=200             # -N

# this next section explains usage with the Structure provided testdata1 input file
# notice how this section modifies the mainparams file to match the testdata1 input
# since the first line of testdata1 does not contain marker names
if [[ $input_file = 'testdata1' ]]; then
    sed -i 's/#define MARKERNAMES      1/define MARKERNAMES      0/' mainparams
fi
# the diploid testdata1 has the following columns:
# individual population locus1 locus2 locus3 locus4 locus5 locus6
<<INPUT_FORMAT
1 1 0 0 1 3 8 9
1 1 0 1 -1 -1 7 -3
2 1 0 -1 2 2 6 7
2 1 0 0 5 0 9 7
INPUT_FORMAT
################################### COMMANDS ###################################
# 
structure -i $input_file -o $output_file -K $num_populations -L $num_loci -N $num_individuals

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Structure:
            Pritchard JK, Stephens M, Donnelly P. Inference of population structure using 
            multilocus genotype data. Genetics. 2000. Jun:155(2):945-59.
CITATION
