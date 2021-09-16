##Input count table
counttable = read.csv("counttable_PCA.csv", header = TRUE, row.names = 1, sep = ",")
head(counttable)
counttable = round(counttable,digits = 0)
head(counttable)
##The dim must have only columns representing the samples
dim(counttable)

##colData creation
condition = c("A2780 cont","A2780 cont","A2780 cont","A2780 cisplatin","A2780 cisplatin","A2780 cisplatin", "Acis cont", "Acis cont", "Acis cont", "Acis cisplatin", "Acis cisplatin", "Acis cisplatin")
colData = data.frame(row.names=colnames(counttable), treatment=factor(condition, levels=c("A2780 cont","A2780 cisplatin","Acis cont", "Acis cisplatin")))
colData                   

########################## PCA PLOT ##########################

count_column=1

experiment_formula="Sample:Replicate"

sample_names="A2780 cont:Replicate 1, A2780cont:Replicate 2, A2780cont:Replicate 3, A2780 cisplatin:Replicate 1, A2780 cisplatin:Replicate 2, A2780 cisplatin:Replicate 3, Acis cont:Replicate 1, Acis cont:Replicate 2, Acis cont:Replicate 3, Acis cisplatin:Replicate 1, Acis cisplatin:Replicate 2, Acis cisplatin:Replicate 3"

# we get the counts
counts = read.table("counttable_PCA.csv")
rownames(counts) = counts[,1]
counts_information = counts[, c(1:count_column) ]
counts_total = counts[, dim(counts)[2]]
counts = counts[, -c(1:count_column, dim(counts)[2]) ]
head(counts)
# we get the variables
variable_names = strsplit(experiment_formula, "[:]")[[1]]
sample_names = strsplit(sample_names,",")[[1]]
variables = strsplit(sample_names[1], "[:]")[[1]]
variable_number = length(variables)

for( i in c(2:length(sample_names)))
{
  variable = strsplit(sample_names[i], "[:]")[[1]]
  variables = cbind(variables, variable)
}
variables = t(variables)
rownames(variables) = sample_names
colnames(variables) =  variable_names
variables = as.data.frame(variables)
variables

library(DESeq2)
ntop = 500
rld = rlogTransformation(dds, blind=T)
rv = rowVars(assay(rld))
select = order(rv, decreasing = TRUE)[seq_len(min(ntop, length(rv)))]
pca = prcomp(t(assay(rld)[select, ]))

library(ggplot2)
x = ggplot(data=as.data.frame(pca$x), aes(PC1, PC2, color=variables[,1], shape=variables[,2] )) +
  geom_point(size = 6) +
  xlab(paste0("PC1: ",100*summary(pca)[6]$importance[2,][1],"% of variance")) +
  ylab(paste0("PC1: ",100*summary(pca)[6]$importance[2,][2],"% of variance")) +
  ggtitle("PCA") +
  theme(plot.title = element_text(hjust = 0.5)) +
  guides(color=guide_legend(title=variable_names[1]), shape=guide_legend(title=variable_names[2]))

plot(x)
