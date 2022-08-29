#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=structure        # job name
#SBATCH --time=01:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=1           # CPUs (threads) per command
#SBATCH --mem=7G                    # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/8.3.0 Structure/2.3.4

<<README
    - Structure manual:
        https://web.stanford.edu/group/pritchardlab/structure_software/release_versions/v2.3.4/structure_doc.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
input_file='testdata1'          # -i

######## PARAMETERS ########
# edit the following to match your population (current settings are for testdata1)
num_populations=2               # -K
num_loci=6                      # -L
num_individuals=200             # -N

if [[ $input_file = 'testdata1' ]]; then
  # copy the mainparams, extraparams and testdata1 to current directory
  cp $EBROOTSTRUCTURE/bin/{mainparams,extraparams} ./
  chmod u+w *params
  cp /scratch/data/bio/structure/testdata1 ./

  # The diploid testdata1 data are simulated microsatellite data with 200 diploid individuals from 2 populations:
  # LABEL=1, POPDATA=1, POPFLAG=1, NUMLOCI=5, PLOIDY=2, MISSING=-999, ONEROWPERIND=0
  # The diploid testdata1 has the following columns:
  # individual population locus1 locus2 locus3 locus4 locus5 locus6

  # this next section explains usage with the Structure provided testdata1 input file
  # notice how this section modifies MARKERNAMES in the mainparams file to match the testdata1 input
  # changes default 1 to 0 since the first line of testdata1 does not contain marker names
  if [[ $input_file = 'testdata1' ]]; then
    sed -i 's/#define MARKERNAMES      1/define MARKERNAMES      0/' mainparams
  fi
fi

########## OUTPUTS #########
output_file='output_testdata1'  # -o

################################### COMMANDS ###################################

structure -i $input_file -o $output_file -K $num_populations -L $num_loci -N $num_individuals

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Structure:
            Pritchard JK, Stephens M, Donnelly P. Inference of population structure using
            multilocus genotype data. Genetics. 2000. Jun:155(2):945-59.
CITATION
