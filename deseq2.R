##Install BiocManager-deseq
if (!requireNamespace("BiocManager", quietly = TRUE))
install.packages("BiocManager")

BiocManager::install("DESeq2", force = TRUE)

library(DESeq2)

##Input count table
counttable = read.csv("A2780xA2780t.csv", header = TRUE, row.names = 1, sep = ",")
head(counttable)

##The dim must has only columns representing the samples
dim(counttable)

##colData creation
condition = c("control","control","control","treatment","treatment","treatment")
colData = data.frame(row.names=colnames(counttable), treatment=factor(condition, levels=c("control","treatment")))
colData                    

##Differential expression analysis
dataset <- DESeqDataSetFromMatrix(countData = counttable, colData = colData, design = ~treatment)
dataset
dds = DESeq(dataset)
head(dds)
result = results(dds, contrast=c("treatment","control"))
write.table(result, file="A2780xA2780t_deseq.csv", sep = ",")
