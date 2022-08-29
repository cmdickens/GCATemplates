#BSUB -L /bin/bash              # uses the bash login shell for the job's execution environment.
#BSUB -J blastx_4nodes          # job name
#BSUB -n 80                     # assigns 80 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid
#BSUB -app resizable            # dynamically release cores as job finishes

module load UCSCtools/2018-06-05
module load SeqKit/0.9.3-linux-x86_64
module load BLAST+/2.7.1-intel-2017A

<<README
    - BLAST+ manual: http://www.ncbi.nlm.nih.gov/books/NBK279675/

    - Tamulauncher: this script can be resubmitted without any edits if your
                    job stops due to running out of memory, disk space or runtime
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
input_fasta_file='/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_rna-seq_assembly_SRR575493_Trinity.fasta'

######## PARAMETERS ########
# look for available BLAST protein databases in the directory /scratch/datasets/uniprot_sprot/
blast_db='/scratch/datasets/uniprot_sprot/uniprot_sprot.fasta'
task='blastx'                   # blastx, blastx-fast
cmds_file="tamulauncher_${task}_cmds.txt"

evalue='0.001'
outfmt='6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles'
additional_blast_options=''     # Example: -num_alignments 5
min_length_to_blast=50
num_split_files=500

########## OUTPUTS #########
output_blast_file="${task}_out.tsv"

################################### COMMANDS ###################################
# STEP 1.
# This step does not need to be edited but you can make changes to the blast command as needed
if [[ ! -f $input_fasta_file ]]; then
    (>&2 echo "The input file $input_fasta_file does not exist")
    exit 1
fi
if [[ ! -f $cmds_file && ! -d .tamulauncher-log ]]; then
    mkdir tmp_${task}
    # sort sequences shortest to longest to facilitate tamulauncher job
    seqkit sort --quiet -l $input_fasta_file | seqkit seq --quiet --min-len $min_length_to_blast > sorted.fasta && \
    faSplit sequence sorted.fasta $num_split_files tmp_${task}/chunk
    
    # build a text file containing one BLAST command for each sequence file
    for file in tmp_${task}/chunk*fa; do
        echo "$task -query $file -db $blast_db  -task $task -evalue $evalue -out $file.out -outfmt '$outfmt' -num_threads 1 $additional_blast_options" >> $cmds_file
    done
fi

# STEP 2.
# run BLAST using tamulauncher and combine results into one file
tamulauncher $cmds_file && \
cat tmp_${task}/chunk*out > $output_blast_file

# remove temporary files created in STEP 1.
#rm sorted.fasta
#rm tmp_${task}/chunk*

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - BLAST+:
        Camacho C., Coulouris G., Avagyan V., Ma N., Papadopoulos J., Bealer K., & Madden T.L. (2008)
        "BLAST+: architecture and applications." BMC Bioinformatics 10:421.

    - SeqKit:
        Shen W, Le S, Li Y, Hu F (2016) SeqKit: A Cross-Platform and Ultrafast Toolkit for FASTA/Q File Manipulation.
        PLoS ONE 11(10): e0163962. https://doi.org/10.1371/journal.pone.0163962
CITATION
