#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J kallisto               # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=3000]"     # reserves 3000MB memory per core
#BSUB -M 3000                   # sets to 3000MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load kallisto/0.43.1-intel-2017A

<<README
    - kallisto manual: https://pachterlab.github.io/kallisto/manual
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed: also deit pe1_1 and pe1_2
bootstrap=100

# kallisto index -i <index_name> <reference_transcriptome_file>
kallisto index -i transcripts.idx rna.fa

for sample in SRR364313 SRR364314 SRR364315 SRR364316
do
  pe1_1="../sra_reads/${sample}_1.fastq.gz"
  pe1_2="../sra_reads/${sample}_2.fastq.gz"

  mkdir -p results_raw/$sample/kallisto

  kallisto quant -i transcripts.idx -b $bootstrap -o results_raw/$sample/kallisto $pe1_1 $pe1_2
done

exit 0
################################### COMMANDS ###################################
# here are some sample commands from the sleuth webpage on how to process your kallisto results
module load R_modules/3.2.5-iomkl-2015B-default-mt
module load sleuth/0.28.0-iomkl-2015B-R-3.2.5-default-mt

# here is an example of the config file needed by sleuth
echo "run_accession experiment_accession spots condition sequencer sample
SRR364315 SRX105525 39514555 SF hiseq A
SRR364316 SRX105526 40743305 SF hiseq B
SRR364313 SRX105523 43961007 RASF hiseq C
SRR364314 SRX105524 40979515 RASF hiseq D" >> hiseq_info.txt

# start an R session and use the following commands

library("sleuth")
base_dir <- "/scratch/user/cmdickens/synovial/kallisto"
sample_id <- dir(file.path(base_dir,"results"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results", id, "kallisto"))
s2c <- read.table(file.path(base_dir, "hiseq_info.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = run_accession, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)
print(s2c)
so <- sleuth_prep(s2c, ~ condition)
so <- sleuth_fit(so)
so <- sleuth_wt(so, 'conditionSF')
models(so)

results_table <- sleuth_results(so, 'conditionSF')
write.csv(results_table, 'out_sleuth_r')

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - kallisto: http://pachterlab.github.io/kallisto/

    - sleuth: http://pachterlab.github.io/sleuth/
CITATION
