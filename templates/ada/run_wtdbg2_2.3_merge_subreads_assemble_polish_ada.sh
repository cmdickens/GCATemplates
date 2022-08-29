#BSUB -L /bin/bash              # use the bash login shell for the job's execution environment.
#BSUB -J wtdbg2                 # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. Total memory = (M * n)
#BSUB -W 24:00                  # sets to 24 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load wtdbg2/2.3-foss-2018b
module load BamTools/2.5.1-foss-2018b
module load SAMtools/1.9-foss-2018b
module load minimap2/2.15-GCCcore-7.3.0

<<README
    - wtdbg2 Manual: https://github.com/ruanjue/wtdbg2
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# a file named input.fofn with one subreads.bam file per line is required
subreads_files_list='/scratch/datasets/GCATemplates/data/pacbio/arabidopsis_thaliana/input.fofn'

######## PARAMETERS ########
threads=20
seq_type='sq'                   # sq (sequel), ont, ccs, rs
genome_size='135m'

########## OUTPUTS #########
out_prefix='a_thaliana'

################################### COMMANDS ###################################
# convert bam to fasta; only needs to be done once; only merge if file does not exist or is too small to be correct
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

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - wtdbg2: https://github.com/ruanjue/wtdbg2    
CITATION
