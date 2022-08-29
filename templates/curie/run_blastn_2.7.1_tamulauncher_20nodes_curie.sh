#BSUB -L /bin/bash              # uses the bash login shell for the job's execution environment.
#BSUB -J blastn_20nodes         # job name
#BSUB -n 320                    # assigns 320 cores for execution (20 nodes)
#BSUB -R "span[ptile=16]"       # assigns 16 cores per node
#BSUB -R "rusage[mem=12300]"    # reserves 12300MB memory per core
#BSUB -M 12300                  # sets to 12300MB per process enforceable memory limit. (M * n)
#BSUB -W 168:00                 # sets to 168 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid
#BSUB -app resizable            # dynamically release cores as job finishes

module load BBMap/38.32-foss-2018b
module load Exonerate/2.4.0-foss-2018b
module load BLAST+/2.7.1-foss-2018b

<<README
    - BLAST+ manual: http://www.ncbi.nlm.nih.gov/books/NBK279675/
README

################################################################################
# TODO Edit these variables as needed:
input_fasta_file='/scratch/datasets/GCATemplates/data/sra/e_coli/ecoli_rna-seq_assembly_SRR575493_Trinity.fasta'

task='blastn'                   # blastn, blastn-short, dc-megablast, megablast, rmblastn
# look for available BLAST nucleotide databases in the directory /scratch/datasets/BLAST/
# ls /scratch/datasets/BLAST/*.gz.md5 | cut -f 1 -d '.' | uniq
blast_db='/scratch/datasets/BLAST/16SMicrobial'
evalue='0.001'
outfmt='6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles'
additional_blast_options=''     # Example: -num_alignments 5

num_split_files=5000

output_cmds_file="tamulauncher_${task}_cmds.txt"
output_blast_file="${task}_out.tsv"

################################################################################
# STEP 1.
# This section does not need to be edited but you can make changes to the blast command as needed
if [[ ! -f $input_fasta_file ]]; then
    (>&2 echo "The input file $input_fasta_file does not exist")
    exit 1
fi
if [[ ! -f $output_cmds_file && ! -d .tamulauncher-log ]]; then
    mkdir tmp_${task}
    # sort sequences shortest to longest to facilitate tamulauncher job
    sortbyname.sh in=$input_fasta_file out=sorted_for_${task}.fasta length ascending
    fastasplit --fasta sorted_for_${task}.fasta --output tmp_${task} --chunk $num_split_files
    
    # build a text file containing one BLAST command for each sequence file
    for file in tmp_${task}/*_chunk_*; do
        echo "$task -query $file -db $blast_db -task $task -evalue $evalue -out $file.out -outfmt '$outfmt' -num_threads 1 $additional_blast_options" >> $output_cmds_file
    done
fi

# STEP 2.
# run BLAST using tamulauncher and combine results into one file
tamulauncher $output_cmds_file && \
cat tmp_${task}/*_chunk_*out > $output_blast_file

# remove temporary files
#rm sorted_for_${task}.fasta
#rm tmp_${task}/*_chunk_*

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Exonerate:
        Slater GS and Birney E (2005) Automated generation of heuristics for biological sequence comparison.
        BMC Bioinformatics 6:31; doi: 10.1186/1471-2105-6-31

    - BBMap:
        https://jgi.doe.gov/data-and-tools/bbtools
CITATION
