#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=wtdbg2           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load wtdbg2/2.3-foss-2018b
module load BamTools/2.5.1-GCCcore-7.3.0
module load SAMtools/1.8-GCCcore-7.3.0
module load minimap2/2.17-GCCcore-7.3.0

<<README
    - wtdbg2 Manual: https://github.com/ruanjue/wtdbg2
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# a file named input.fofn with one subreads.bam file per line is required
subreads_files_list='/scratch/data/bio/GCATemplates/pacbio/arabidopsis_thaliana/input.fofn'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK
seq_type='sq'                   # sq (sequel), ont, ccs, rs
genome_size='135m'

########## OUTPUTS #########
out_prefix='a_thaliana'

################################### COMMANDS ###################################
# merge and convert subreads.bam files to a single fasta file; only merge if file does not exist or is too small to be correct
if [ ! -f ${out_prefix}_merged_subreads.fa.gz ]  || [ $(stat -c%s ${out_prefix}_merged_subreads.fa.gz) -lt 50 ]; then
  bamtools convert -format fasta -list $subreads_files_list | gzip > ${out_prefix}_merged_subreads.fa.gz
fi

# assemble long reads
wtdbg2 -t $threads -g $genome_size -i ${out_prefix}_merged_subreads.fa.gz -x $seq_type -o $out_prefix

# derive consensus
wtpoa-cns -t $threads -i ${out_prefix}.ctg.lay.gz -o ${out_prefix}.ctg.fa

# polish consensus
minimap2 -t $threads -x map-pb -a ${out_prefix}.ctg.fa ${out_prefix}_merged_subreads.fa.gz \
    | samtools sort -T ${out_prefix}.srt.tmp -m 1G --threads $threads -o ${out_prefix}.ctg.map.srt.bam -
 samtools view ${out_prefix}.ctg.map.srt.bam | wtpoa-cns -t $threads -d ${out_prefix}.ctg.fa -i - -fo ${out_prefix}.ctg.2nd.fa

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - wtdbg2: https://github.com/ruanjue/wtdbg2    
CITATION
