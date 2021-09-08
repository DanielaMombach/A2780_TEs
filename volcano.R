res = read.csv("A2780xA2780t_deseq.csv", sep = ",", header = TRUE)

# Volcano plot 2
sig = rownames(subset(res, padj<0.05 & log2FoldChange>1))
red = rep("red",length(sig))
names(red) = sig

sip = rownames(subset(res, padj<0.05 & log2FoldChange<(-1)))
blue = rep("blue",length(sip))
names(blue) = sip

nsi = rownames(subset(res, !rownames(res) %in% c(sig,sip)))
darkgrey = rep("grey23",length(nsi))
names(darkgrey) = nsi

sum(length(sig),length(sip),length(nsi))
colScale = c(blue,darkgrey,red)
colScale = colScale[order(match(names(colScale),rownames(res)))]

svg(filename = "A2780xA2780t_volcano.svg", width=3, height = 3, pointsize = 5)

graph = plot(res$log2FoldChange, -log10(res$padj), col=colScale,  panel.first=grid(),
             main="A2780 x A2780t", xlab="log2 fold-change", ylab="-log10 FDR",
             pch=20, cex=2,xlim=c(-5,5),ylim=c(0,30))

abline(v = -1, col = "black", lty = 3, lwd = 2)
abline(v = 1, col = "black", lty = 3, lwd = 2)
abline(h = -log10(max(res$padj[res$padj<0.05], na.rm = TRUE)), col = "black", lty = 3, lwd = 2)

geneselected = abs(res$log2FoldChange) > 1 & res$padj < 0.05 ### => pode-se trocar essa funcao por uma lista de interesse
text(x = res$log2FoldChange[geneselected],
     y = -log10(res$padj)[geneselected] - 0.1,
     labels = res$id[geneselected], cex = 1)