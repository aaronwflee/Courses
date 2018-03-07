library(devtools)
install_github("genomicsclass/tissuesGeneExpression")
library(tissuesGeneExpression)
data(tissuesGeneExpression)
head(e)
head(tissue)

## see breakdown of replicates in each
table(tissue)

## calculate all distances
d <- dist(t(e))
as.matrix(d)[3, 45]
## or get specific distance between two columns using pythogoras
sqrt( sum((e[,3]-e[,45])^2 ))

## get specific distance between two genes
sqrt( sum((e[c('210486_at'),] - e[c('200805_at'),] )^2))

dim(e)[1]* dim(e)[1]
## 22215*22215 = 493506225


