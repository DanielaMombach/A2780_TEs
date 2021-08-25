
#!/bin/bash

#BASH SCRIPT FOR RNASEQ ANALYSIS

set -e

###Mask TEs
bedtools maskfasta -fi GCF_000001405.25_GRCh37.p13_genomic.fna -bed hg19_TEs.bed -fo out_bedtools.fasta
bedtools getfasta -name -fi GCF_000001405.25_GRCh37.p13_genomic.fna -bed hg19_genes.bed

###Define variables (directories, softwares, array of data names)
DIR="/mnt/7f39cef6-de77-4920-a0e8-54114cd9efd3/danidoc"

DIRFASTQ="$DIR"
DIRREF=/mnt/7f39cef6-de77-4920-a0e8-54114cd9efd3/danidoc
DIRALIGN="$DIR"/align
DIRCOUNTREADS="$DIR"/countreads
DIRCOUNTTE="$DIR"/countte

HISAT2=/usr/bin/hisat2
HISAT2BUILD=/usr/bin/hisat2-build
SAMTOOLS=/usr/bin/samtools
EXPRESS=/home/labdros/softwares/express-1.5.1/express

REF=reference_genome

###Create index of the reference genome with hisat2
echo -e "\n*---------- CREATE INDEX"
"$HISAT2BUILD" -p 4 -f "$DIRREF"/"$REF".fasta "$DIRREF"/"$REF""_hisat2.index"


###Align reads to the reference genome with hisat2

	echo -e "\n*---------- ALIGN READS control 1 TO THE REF GENOME"
	"$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/SRR14310037.fastq -S "$DIRALIGN"/A2780_rep1.sam

	echo -e "\n*---------- ALIGN READS control 2 TO THE REF GENOME"
	"$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/SRR14310038.fastq -S "$DIRALIGN"/A2780_rep2.sam

	echo -e "\n*---------- ALIGN READS control 3 TO THE REF GENOME"
	"$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/SRR14310039.fastq -S "$DIRALIGN"/A2780_rep3.sam

	echo -e "\n*---------- ALIGN READS treatment 1 TO THE REF GENOME"
	"$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/SRR143100343.fastq -S "$DIRALIGN"/A2780t_rep1.sam

	echo -e "\n*---------- ALIGN READS treatment 2 TO THE REF GENOME"
	"$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/SRR143100344.fastq -S "$DIRALIGN"/A2780t_rep2.sam

	echo -e "\n*---------- ALIGN READS treatment 3 TO THE REF GENOME"
	"$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/SRR143100345.fastq -S "$DIRALIGN"/A2780t_rep3.sam


###Convert SAM files to BAM

	echo -e "n*-----------control 1 SAM TO BAM"
	"$SAMTOOLS" view -bS "$DIRALIGN"/A2780_rep1.sam > "$DIRALIGN"/A2780_rep1.bam
	echo -e "n*-----------control 1 SAM EXCLUDING"
        rm -R "$DIRALIGN"/A2780_rep1.sam

	echo -e "n*-----------control 2 SAM TO BAM"
        "$SAMTOOLS" view -bS "$DIRALIGN"/A2780_rep2.sam > "$DIRALIGN"/A2780_rep2.bam
	echo -e "n*-----------control 2 SAM EXCLUDING"
        rm -R "$DIRALIGN"/A2780_rep2.sam

	echo -e "n*-----------control 3 SAM TO BAM"
        "$SAMTOOLS" view -bS "$DIRALIGN"/A2780_rep3.sam > "$DIRALIGN"/A2780_rep3.bam
	echo -e "n*-----------control 3 SAM EXCLUDING"
	rm -R "$DIRALIGN"/A2780_rep3.sam

	echo -e "n*-----------treatment 1 SAM TO BAM"
	"$SAMTOOLS" view -bS "$DIRALIGN"/A2780t_rep1.sam > "$DIRALIGN"/A2780t_rep1.bam
	echo -e "n*-----------treatment 1 SAM EXCLUDING"
	rm -R "$DIRALIGN"/A2780t_rep1.sam
	
	echo -e "n*-----------treatment 2 SAM TO BAM"
	"$SAMTOOLS" view -bS "$DIRALIGN"/A2780t_rep2.sam > "$DIRALIGN"/A2780t_rep2.bam
	echo -e "n*-----------treatment 2 SAM EXCLUDING"
	rm -R "$DIRALIGN"/A2780t_rep2.sam
	
	echo -e "n*-----------treatment 3 SAM TO BAM"
	"$SAMTOOLS" view -bS "$DIRALIGN"/A2780t_rep3.sam > "$DIRALIGN"/A2780t_rep3.bam
	echo -e "n*-----------treatment 3 SAM EXCLUDING"
	rm -R "$DIRALIGN"/A2780t_rep3.sam
	

###Count reads per gene with express

	echo -e "\n*---------- COUNT READS PER GENE"
	"$EXPRESS" -o "$DIRCOUNTREADS"/A2780_rep1 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN"/A2780_rep1.bam
	
	"$EXPRESS" -o "$DIRCOUNTREADS"/A2780_rep2 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN"/A2780_rep2.bam

	"$EXPRESS" -o "$DIRCOUNTREADS"/A2780_rep3 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN"/A2780_rep3.bam
	
	"$EXPRESS" -o "$DIRCOUNTREADS"/A2780t_rep1 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN"/A2780t_rep1.bam

	"$EXPRESS" -o "$DIRCOUNTREADS"/A2780t_rep2 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN"/A2780t_rep2.bam

	"$EXPRESS" -o "$DIRCOUNTREADS"/A2780t_rep3 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN"/A2780t_rep3.bam
