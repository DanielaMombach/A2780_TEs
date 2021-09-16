plot(rnorm(50), rnorm(50))

res = read.csv("A2780xA2780cis_all_TEs.csv", sep = ",", header = TRUE)

# Volcano plot 2
sig = rownames(subset(res, padj<0.05 & log2FoldChange>0))
red = rep("red",length(sig))
names(red) = sig

sip = rownames(subset(res, padj<0.05 & log2FoldChange<(0)))
blue = rep("blue",length(sip))
names(blue) = sip

nsi = rownames(subset(res, !rownames(res) %in% c(sig,sip)))
darkgrey = rep("grey23",length(nsi))
names(darkgrey) = nsi

sum(length(sig),length(sip),length(nsi))
colScale = c(blue,darkgrey,red)
colScale = colScale[order(match(names(colScale),rownames(res)))]

graph = plot(res$log2FoldChange, -log10(res$padj), col=colScale,  panel.first=grid(),
             main="A2780 x A2780cis", xlab="log 2 fold-change", ylab="-log10 padj",
             pch=20, cex=2,xlim=c(-5,5),ylim=c(0,055))
