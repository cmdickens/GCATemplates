#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J tassel                 # job name
#BSUB -n 5                      # assigns 5 cores for execution
#BSUB -R "span[ptile=5]"        # assigns 5 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB (~1GB) per process enforceable memory limit. (M * n)
#BSUB -W 2:00                   # sets to 2 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load TASSEL/5.2.12-Java-1.8.0_51

<<README
    - TASSEL: software for association mapping of complex traits in diverse samples

    - TASSEL manual:
        https://bytebucket.org/tasseladmin/tassel-5-source/wiki/docs/Tassel5PipelineCLI.pdf
        https://bitbucket.org/tasseladmin/tassel-5-source/wiki/browse/UserManual
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
# for sample data files: ls $EBROOTTASSEL/TASSELTutorialData/data/
data_file='mdp_genotype.hmp.txt'


# create a config file; find sample config fiels at $EBROOTTASSEL/example_pipelines/
echo "<?xml version='1.0' encoding='UTF-8' standalone='no'?>
<TasselPipeline>
    <fork1>
        <h>$data_file</h>
        <ld>
            <ldType>All</ldType>
        </ld>
        <ldd>
            png
            <ldplotsize>500</ldplotsize>
            <o>output_ld.png</o>
        </ldd>
    </fork1>
    <runfork1/>
</TasselPipeline>" > config.xml

################################### COMMANDS ###################################
# 
perl $EBROOTTASSEL/run_pipeline.pl -configFile config.xml

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - TASSEL:
        Bradbury P, Zhang Z, Kroon D, Casstevens T, Ramdoss Y, and Buckler, E.
        TASSEL: software for association mapping of complex traits in diverse samples. Bioinformatics (2007) 23 (19): 2633-2635.
CITATION
