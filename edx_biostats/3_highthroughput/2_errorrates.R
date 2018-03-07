library(devtools)
library(rafalib)
install_github("genomicsclass/GSE5859Subset")
install_bioc("genefilter")
install_bioc("qvalue")

## intro to error rates

1-(0.00000001**8793)

minpval <- replicate(1000, min(runif(8793,0,1))<0.00000585)
mean(minpval>=1)

0.05/8793


## speed of sapply vs matrix calculations
library(downloader)
url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleControlsPopulation.csv"
filename <- "femaleControlsPopulation.csv"
if (!file.exists(filename)) download(url,destfile=filename) 
set.seed(1)
population = unlist( read.csv("femaleControlsPopulation.csv") )

alpha <- 0.05
N <- 12
m <- 10000
p0 <- 0.90 ##10% of diets work, 90% don't
m0 <- m*p0
m1 <- m-m0
nullHypothesis <- c( rep(TRUE,m0), rep(FALSE,m1))
delta <- 3

## SAPPLY
B <- 10 ##number of simulations 
system.time(
  VandS <- replicate(B,{
    calls <- sapply(1:m, function(i){
      control <- sample(population,N)
      treatment <- sample(population,N)
      if(!nullHypothesis[i]) treatment <- treatment + delta
      t.test(treatment,control)$p.val < alpha
    })
    c(sum(nullHypothesis & calls),sum(!nullHypothesis & calls))
  })
)
## MATRIX
library(genefilter) ##rowttests is here
set.seed(1)
##Define groups to be used with rowttests
g <- factor( c(rep(0,N),rep(1,N)) )
B <- 10 ##number of simulations
system.time(
  VandS <- replicate(B,{
    ##matrix with control data (rows are tests, columns are mice)
    controls <- matrix(sample(population, N*m, replace=TRUE),nrow=m)
    
    ##matrix with control data (rows are tests, columns are mice)
    treatments <-  matrix(sample(population, N*m, replace=TRUE),nrow=m)
    
    ##add effect to 10% of them
    treatments[which(!nullHypothesis),]<-treatments[which(!nullHypothesis),]+delta
    
    ##combine to form one matrix
    dat <- cbind(controls,treatments)
    
    calls <- rowttests(dat,g)$p.value < alpha
    
    c(sum(nullHypothesis & calls),sum(!nullHypothesis & calls))
  })
)



# Bonferroni and Sidak Correction --------------------------------------------------------------

alphas <- seq(0,0.25,0.01)

## bonferroni = alpha/number of tests
## sidak = 1−(1−alpha)1/number of tests

alphas <- seq(0,0.25,0.01)
par(mfrow=c(2,2))
for(m in c(2,10,100,1000)){
  plot(alphas,alphas/m - (1-(1-alphas)^(1/m)),type="l")
  abline(h=0,col=2,lty=2)
}


## comparing FWER of the two
alpha = 0.05
m = 8793
## bonferroni simulation
set.seed(1)
fwer <- replicate(10000, {
  pvals <- runif(m,0,1)
  cutoff = alpha/m
  sum(pvals < cutoff)
  })

mean(fwer)

## sidak simulation

set.seed(1)
fwer <- replicate(10000, {
  pvals <- runif(m,0,1)
  cutoff = (1-(1-alpha)^(1/m))
  sum(pvals < cutoff)
})

mean(fwer)



# False discovery rates ---------------------------------------------------
library(GSE5859Subset)
library(genefilter)
data(GSE5859Subset)
?rowttests
f <- factor(sampleInfo$group)
pvals <- rowttests(geneExpression, fac = f)[,3]
sum(pvals<0.05)
sum(pvals<0.05/8793)

## To define the q-value we order features we tested by p-value then compute the FDRs for a list with the most significant,
## the two most significant, the three most significant, etc... The FDR of the list with the, say, 
## m most significant tests is defined as the q-value of the m-th most significant feature. 
## In other words, the q-value of a feature, is the FDR of the biggest list that includes that gene.

fdr_pvals <- p.adjust(pvals, method = "fdr")
sum(fdr_pvals<0.05)

library(qvalue)
qs <- qvalue(pvals)
## number of q values < 0.05
sum(qs$qvalues<0.05)

## proportion of null == True tests
qs$pi0

qvals <- qs$qvalues
plot(qvals/fdr_pvals)



# Advanced Simulation -----------------------------------------------------

## wrong attempt
n <- 24
m <- 8293
mat <- matrix(rnorm(n*m),m,n)
delta <- 2
positives <- 500
mat[1:positives,1:(n/2)] <- mat[1:positives,1:(n/2)]+delta
set.seed(1)
b_results <- replicate(1000, {
  pvals <- rowttests(mat, fac = f)[,3]
  bf_vals <- pvals/8793
  return(bf_vals)
  })
mb_results <- rowMeans(b_results, dims = 1)
m0 = 8293
m1 = 500
(sum(mb_results[500:8793]<0.05/8793))/m0


### actual solution: 
n <- 24
m <- 8793
B <- 1000
delta <-2
positives <- 500
g <- factor(rep(c(0,1),each=12))

set.seed(1)
## Bonferroni False positive rate
result <- replicate(B,{
  mat <- matrix(rnorm(n*m),m,n)
  mat[1:positives,1:(n/2)] <- mat[1:positives,1:(n/2)]+delta
  pvals = rowttests(mat,g)$p.val
  tp_pvals = pvals[1:500]
  tn_pvals = pvals[501:8793]
  ##Bonferroni
  B_FP <- sum(tn_pvals<=0.05/m)  
  B_FN <- sum(tp_pvals>0.05/m)
  ##FDR Q values
  qvals1 = p.adjust(pvals,method="fdr")
  F_FP <- sum(qvals1[-(1:positives)]<=0.05)
  F_FN <- sum(qvals1[1:positives]>0.05)
  ##Direct Q values
  qvals2 = qvalue(pvals)$qvalue
  Q_FP <- sum(qvals2[-(1:positives)]<=0.05)
  Q_FN <- sum(qvals2[1:positives]>0.05)  
#  Q_FN <- sum(qvalue(tp_pvals)$qvalues < 0.05)
  return(c(B_FP, B_FN, F_FP, F_FN, Q_FP, Q_FN))
})

## FP rate (FP/FP+TN), i.e., denominator = m-positives = 8293
## FN rate (FN/FN+TP), i.e., denominator = positives = 500

## Bonferroni
mean(result[1,]/(m-positives))
mean(result[2,]/(positives))

## FDR
mean(result[3,]/(m-positives))
mean(result[4,]/(positives))

## Q values
mean(result[5,]/(m-positives))
mean(result[6,]/(positives))
