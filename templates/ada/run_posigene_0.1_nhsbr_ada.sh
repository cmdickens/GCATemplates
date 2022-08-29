#BSUB -L /bin/bash              # uses the bash login shell for the job's execution environment.
#BSUB -J posigene               # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load PosiGene/0.1-GCCcore-6.3.0-Perl-5.24.0

<<README
    - PosiGene manual:
        do the following on the command line after logging with ssh -X and loading the PosiGene module:
            evince $EBROOTPOSIGENE/doc/User_Guide.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
reference_species="Acromyrmex_echinatior:$EBROOTPOSIGENE/test_data/Acromyrmex_echinatior_sample.fasta"
anchor_species_name='Harpegnathos_saltator'

non_homologene_species_by_reference="Acromyrmex_echinatior:$EBROOTPOSIGENE/test_data/Acromyrmex_echinatior_sample.fasta,Atta_cephalotes:$EBROOTPOSIGENE/test_data/Atta_cephalotes_sample.fasta,Camponotus_floridanus:$EBROOTPOSIGENE/test_data/Camponotus_floridanus_sample.fasta,Harpegnathos_saltator:$EBROOTPOSIGENE/test_data/Harpegnathos_saltator_sample.fasta,Linepithema_humile:$EBROOTPOSIGENE/test_data/Linepithema_humile_sample.fasta,Pogonomyrmex_barbatus:$EBROOTPOSIGENE/test_data/Pogonomyrmex_barbatus_sample.fasta,Solenopsis_invicta:$EBROOTPOSIGENE/test_data/Solenopsis_invicta_sample.fasta"

######## PARAMETERS ########
threads=20

########## OUTPUTS #########
output_dir=$TMPDIR

################################### COMMANDS ###################################
# write results to $TMPDIR and rsync only necessary results upon completion 
PosiGene.pl -tn=$threads -rs=$reference_species -as=$anchor_species_name -nhsbr=$non_homologene_species_by_reference -o=$output_dir

rsync -r --exclude=individual_results $TMPDIR/ posigene_out.${LSB_JOBID}
rsync -r --prune-empty-dirs --include="*/" --include=fastp.clustalw.aln --exclude="*" $TMPDIR/ posigene_out.${LSB_JOBID}

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - PosiGene:
        Sahm A, Bens M, Platzer M, Szafranski K. PosiGene: automated and easy-to-use pipeline
        for genome-wide detection of positively selected genes. Nucleic Acids Res. 2017
        Jun 20;45(11):e100. doi: 10.1093/nar/gkx179.
CITATION
