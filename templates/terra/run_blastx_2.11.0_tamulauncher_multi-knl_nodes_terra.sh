#!/bin/bash
#SBATCH --export=NONE                   # do not export current env to the job
#SBATCH --job-name=blast_tamulauncher   # job name
#SBATCH --time=7-00:00:00               # max job run time dd-hh:mm:ss
#SBATCH --nodes=2                       # total nodes
#SBATCH --ntasks-per-node=68            # tasks (commands) per compute node
#SBATCH --cpus-per-task=1               # CPUs (threads) per command
#SBATCH --mem=80G                       # total memory per node
#SBATCH --partition=knl                 # select KNL nodes
#SBATCH --output=stdout.%x.%j           # save stdout to file
#SBATCH --error=stderr.%x.%j            # save stderr to file

module load BLAST+/2.11.0-gompi-2020b
module load UCSCtools/2018-12-18
module load SeqKit/0.10.0-linux-x86_64

<<README
    - BLAST+ manual: http://www.ncbi.nlm.nih.gov/books/NBK279675/

    - TAMULauncher: this script can be resubmitted without any edits if your
                    job stops due to running out of memory, disk space or runtime
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
input_fasta_file='/scratch/data/bio/GCATemplates/miseq/c_dubliniensis/Trinity.fasta'

######## PARAMETERS ########
seq_chunks=5000
min_length_to_keep=50
evalue='0.001'
outfmt='6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles'
additional_blast_options=''     # Example: -num_alignments 5    do not use -num_threads this is already set in the blast_command below

# look for available BLAST v5 databases in the directory /scratch/data/bio/blast
#   ls /scratch/data/bio/blast/*.gz.md5 | cut -f 1 -d '.' | uniq
blast_db='/scratch/data/bio/blast/nr'
blast_command='blastx'
task='blastx'                # blastx, blastx-fast
cmds_file="tamulauncher_${task}_cmds.txt"

########## OUTPUTS #########
output_blast_file="${task}_out_${SLURM_NNODES}_nodes.tsv"

################################### COMMANDS ###################################
# This section does not need to be edited
if [[ ! -f $input_fasta_file ]]; then
    (>&2 echo "The input file $input_fasta_file does not exist")
    exit 1
fi
if [[ ! -f $cmds_file && ! -d .tamulauncher.log ]]; then
    mkdir tmp
    # sort sequences shortest to longest to facilitate tamulauncher job
    seqkit sort --quiet -l $input_fasta_file | seqkit seq --quiet --min-len $min_length_to_keep > sorted.fasta && \
    faSplit sequence sorted.fasta $seq_chunks tmp/chunk
    
    # build a text file containing one BLAST command for each sequence file
    for file in tmp/chunk*fa; do
        echo "$blast_command -query $file -db $blast_db  -task $task -evalue $evalue -out $file.out -outfmt '$outfmt' -num_threads 1 $additional_blast_options" >> $cmds_file
    done
fi

# run BLAST using tamulauncher and combine results into one file
tamulauncher $cmds_file && \
cat tmp/chunk*out > $output_blast_file

# remove temporary files
rm sorted.fasta
rm tmp/chunk*

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/wiki/index.php/HPRC:AckUs

    - BLAST+:
        Camacho C., Coulouris G., Avagyan V., Ma N., Papadopoulos J., Bealer K., & Madden T.L. (2008)
        "BLAST+
        PLoS ONE 11(10): e0163962. https://doi.org/10.1371/journal.pone.0163962
CITATION
