#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J maker                  # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2700MB memory per core
#BSUB -M 2700                   # sets to 2700MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load MAKER/2.31.10-intel-2017A-Python-2.7.12

<<README
    - MAKER manual: http://weatherby.genetics.utah.edu/MAKER/wiki/index.php/Main_Page
    - MAKER usage: http://onlinelibrary.wiley.com/doi/10.1002/0471250953.bi0411s48/pdf
    - MAKER resources:
        http://www.yandell-lab.org/
        http://yandell-lab.org/software/maker.html
        http://gmod.org/wiki/MAKER_Tutorial
        https://groups.google.com/group/maker-devel?pli=1
README

################################### VARIABLES ##################################
# TODO Edit the maker_opts.ctl file based on your requirements
<<PREREQUISITES
    - GeneMark-ES prerequisite:
        Download the 64_bit key from the following website and save it to your $HOME directory.
        Select the following: GeneMark-ES/ET v4.38  and  LINUX 64
        (you do not need to download the program just the 64_bit key file)
            http://topaz.gatech.edu/GeneMark/license_download.cgi

        Then gunzip the key file and rename it from gm_key_64 to .gm_key

    - Read the pdf at the Maker usage link above to learn about the required control files.

    - Copy the control files prior to running your job script.
        module load MAKER/2.31.10-intel-2017A-Python-2.7.12
        cp /scratch/datasets/maker/2.31.10/*ctl ./

        - Required: edit the maker_opts.ctl file
        - Optional: edit the maker_bopts.ctl file

    - You will need to create a model file using either GeneMark-ES (eukaryotes) or GeneMarkS (prokaryotes) if 
        you want sequences for the modeled genes. Add your GeneMark .mod file at the line: gmhmm= #GeneMark HMM file
        Example command for making a Prokaryotic model file
            module load MAKER/2.31.10-intel-2017A-Python-2.7.12
            gmsn.pl --prok --verbose your_genome.fasta

        Example command for making a Eukaryotic model file
            module load MAKER/2.31.10-intel-2017A-Python-2.7.12
            gmes_petap.pl --cores 4 --ES --sequence your_genome.fasta

    - For a list of augustus species see /software/easybuild/software/AUGUSTUS/3.3.1-intel-2017A/config/species/
PREREQUISITES

########## INPUTS ##########
# Use the full path of your input files (genome.fasta, protein.fasta, est.fasta, ...) in the maker_opts.ctl file

######## PARAMETERS ########
threads=20                  # make sure this matches your #BSUB -n value

########## OUTPUTS #########
# use maker output defaults

################################### COMMANDS ###################################
# 
maker -cpus $threads

# final step is to merge all contig results into one file for fasta and one for gff3
fasta_merge -d dpp_contig.maker.output/dpp_contig_master_datastore_index.log
gff3_merge -d dpp_contig.maker.output/dpp_contig_master_datastore_index.log

# you should review the following log file and look for any tasks in the FAILED state
# dpp_contig.maker.output/dpp_contig_master_datastore_index.log 

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - MAKER:
        Brandi L. Cantarel, Ian Korf, Sofia M.C. Robb, Genis Parra, Eric Ross, Barry Moore, Carson Holt, Alejandro Sánchez Alvarado
        and Mark Yandell. MAKER: An easy-to-use annotation pipeline designed for emerging model organism genomes.
        Genome Res. 2008 Jan; 18(1): 188–196. doi:  10.1101/gr.6743907
CITATION
