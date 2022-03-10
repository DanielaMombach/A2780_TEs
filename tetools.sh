#!/bin/bash

# Master paths
DANIP="/media/labdros/Daniela"
TETOOLS="/home/labdros/software/tetools-master"

# Essential files
ROSETTE="$DANIP/rosette_hg19.txt"
TE_FASTA="$DANIP/rosette_hg19.fa"

# FastQ File paths
FQ_01="$DANIP/SRR14310037.fastq"
FQ_02="$DANIP/SRR14310038.fastq"
FQ_03="$DANIP/SRR14310039.fastq"
FQ_04="$DANIP/SRR14310043.fastq"
FQ_05="$DANIP/SRR14310044.fastq"
FQ_06="$DANIP/SRR14310045.fastq"

# TE output
COUNT_FILE="count_out.txt"
HTML_FILE="$DANIP/"
DIFF_OUTDIR="$DANIP/"

# TE count
python3 $TETOOLS/TEcount.py -bowtie2 -rosette $ROSETTE -column 1 -TE_fasta $TE_FASTA -count $COUNT_FILE -RNA $FQ_01 $FQ_02 $FQ_03 $FQ_04 $FQ_05 $FQ_06
# TE diff
Rscript $TETOOLS/TEdiff.R --args --FDR_level=0.05 --count_column=1 --count_file=\"$COUNT_FILE\" --experiment_formula=\"Treatment:Replicate\" --sample_names=\"A2780:Rep1,A2780:Rep2,A2780:Rep3,A2780t:Rep1,A2780t:Rep2,A2780t:Rep3\" --outdir=\"$DIFF_OUTDIR\" --htmlfile=\"$HTML_FILE\"
echo "Done"
