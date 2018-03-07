library(tissuesGeneExpression)
data(tissuesGeneExpression)


# Singular Value Decomposition (SVD) --------------------------------------

## show that sign flipping gives diff answers
#s = svd(e)
#signflips = sample(c(-1,1),ncol(e),replace=TRUE)
#signflips
#newu= sweep(s$u,2,signflips,FUN="*")
#newv= sweep(s$v,2,signflips,FUN="*" )
#all.equal( s$u %*% diag(s$d) %*% t(s$v), newu %*% diag(s$d) %*% t(newv))


s = svd(e)
m = rowMeans(e)
cor(m, s$u[,1])


## since means do not change distance, make means zero
y = e - rowMeans(e)
s = svd(y)

resid = y - s$u %*% diag(s$d) %*% t(s$v)
max(abs(resid))

diag(s$d)%*%t(s$v)
#is the same as 
s$d * t(s$v)


z = s$d * t(s$v)
sqrt(crossprod(e[,3]-e[,45]))
sqrt(crossprod(y[,3]-y[,45]))
sqrt(crossprod(z[,3]-z[,45]))

dim(z)

## see minimum number of dimensions to get within 10% error
for (k in seq (2:188)) {
  diff = abs(sqrt(crossprod(e[,3]-e[,45])) - sqrt(crossprod(z[1:k,3]-z[1:k,45])))
  if (diff / sqrt(crossprod(e[,3]-e[,45])) < 0.1) {
    print(k)
    stop()
  }
}


distances = sqrt(apply(e[,-3]-e[,3],2,crossprod))
new_distances = sqrt(apply(z[1:2,-3]-z[1:2,3],2,crossprod))
cor(distances, new_distances, method = 'spearman')


# Multiple Dimension Scaling ----------------------------------------------

y = e - rowMeans(e)
s = svd(y)
z = s$d * t(s$v)

## plot mds
library(rafalib)
ftissue = factor(tissue)
mypar(1,1)
plot(z[1,],z[2,],col=as.numeric(ftissue))
legend("topleft",levels(ftissue),col=seq_along(ftissue),pch=1)

## run cmd
d = dist(t(e))
## or remove the row means
# d = dist(t(e - rowMeans(e)))
mds = cmdscale(d)
## correlation between first/second row of z and first/second column of mds
cor(z[2,], mds[,2])

## plot side by side
mypar(1,2)
plot(z[1,]*-1 ,z[2,]*-1 ,col=as.numeric(ftissue))
legend("bottomright",levels(ftissue),col=seq_along(ftissue),pch=1)
plot(mds[,1],mds[,2],col=as.numeric(ftissue))

## using different data
library(GSE5859Subset)
data(GSE5859Subset)

s = svd(geneExpression-rowMeans(geneExpression))
z = s$d * t(s$v)


sampleInfo$group

for (i in seq(1,24)) {
  print(cor(sampleInfo$group, z[i,]))
}

## or use
which.max(cor(sampleInfo$g,t(z)))
max(cor(sampleInfo$g,t(z)))

## rank these correlations
sort(cor(sampleInfo$g,t(z)))


## extract month of data
month = format( sampleInfo$date, "%m")
month = as.numeric(factor( month))

cor(month,t(z))
sort(cor(month,t(z)))

s$u[,5]

print(sampleInfo$group)

