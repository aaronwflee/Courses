
# binomial distribution ---------------------------------------------------

dbinom(2, 4, 0.49)
## which is equal to (nCk)* p^k * (1-p)^(N-k)
choose(4, 2) * 0.49**2 * 0.51 ** (2)
choose(10, 4) * 0.49**4 * 0.51 ** (6)

## what is probability of at least one winning lottery ticket sold
## if probability of winning is 1/175223510 and 189 million tickets are sold
1 - dbinom(0, 189e6, 1/175223510) 
## probability of two or more sold
1 - dbinom(0, 189e6, 1/175223510) - dbinom(1, 189e6, 1/175223510) 


## if given 20 base pairs, what's probability of more than 50% (11)
## of them being C-G pairs if 40% of bases are C-G?
p = 0
for (i in 11:20) {
  p = p + dbinom(i, 20, 0.4)
}
print(p)

## probability that GC-pairs are greater that 35% but smaller or equal to 45%
## 35% is 7, 45% is 9
dbinom(8, 20, 0.4) + dbinom(9, 20, 0.4)

## or to calculate by normal approximation
## k - E(k) / sqrt(Var(k)) where E(k) is Np and Var(k) is Np(1-p)
a <- (9 - 20*0.4)/sqrt(20*0.4*(1-0.4))
b <- (7 - 20*0.4)/sqrt(20*0.4*(1-0.4))
pnorm(a) - pnorm(b)

## with 1000 bases and finding between .35 and 45 (inclusive)
## binomial
p1 = 0
for (i in 351:450) {
  p1 = p1 + dbinom(i, 1000, 0.4)
}
## normal approximation
a <- (450 - 1000*0.4)/sqrt(1000*0.4*(1-0.4))
b <- (350 - 1000*0.4)/sqrt(1000*0.4*(1-0.4))
p2 = pnorm(a) - pnorm(b)
## difference
abs(p1-p2)

## plot simulation
Ns <- c(5,10,30,100)
ps <- c(0.01,0.10,0.5,0.9,0.99)
library(rafalib)
mypar2(4,5)
for(N in Ns){
  ks <- 1:(N-1)
  for(p in ps){
    exact = dbinom(ks,N,p)
    a = (ks+0.5 - N*p)/sqrt(N*p*(1-p))
    b = (ks-0.5 - N*p)/sqrt(N*p*(1-p))
    approx = pnorm(a) - pnorm(b)
    LIM <- range(c(approx,exact))
    plot(exact,approx,main=paste("N =",N," p = ",p),xlim=LIM,ylim=LIM,col=1,pch=16)
    abline(0,1)
  }
}


# Poisson Distribution and Estimation -------------------------------------

## poisson estimation example
## binomial exact
N <- 189000000
p <- 1/175223510
dbinom(2,N,p)
## normal approx does poorly
a <- (2+0.5 - N*p)/sqrt(N*p*(1-p))
b <- (2-0.5 - N*p)/sqrt(N*p*(1-p))
pnorm(a) - pnorm(b)
## poisson approx
dpois(2,N*p)

## poisson approx for 2 or more winning
1 - dpois(1,N*p) - dpois(0,N*p)

## we can use poisson to calculate if rare event is statistically sig
## use maximum likelihood estimation to calculate lambda

## get dataset
library(devtools)
install_github("genomicsclass/dagdata")
library(dagdata)
data(hcmv)
library(rafalib)

mypar()
plot(locations,rep(1,length(locations)),ylab="",yaxt="n")

## break data into bins and plot 
breaks=seq(0,4000*round(max(locations)/4000),4000)
tmp=cut(locations,breaks)
counts=as.numeric(table(tmp))
hist(counts)

## use loop to calculate maximum lambda
max_lambda <- 0
loglikelihood <- -9999
lambdas = seq(0,15,len=300)
for (l in lambdas) {
  logprobs <- dpois(counts,l,log=TRUE)
  if (sum(logprobs) >= loglikelihood) {
    loglikelihood <- sum(logprobs)
    max_lambda <- l
  }
}
print(c(max_lambda, loglikelihood))

breaks=seq(0,4000*round(max(locations)/4000),4000)
tmp=cut(locations,breaks)
counts=as.numeric(table(tmp))
binLocation=(breaks[-1]+breaks[-length(breaks)])/2
plot(binLocation,counts,type="l",xlab=)

## get bin of highest count
i <- (14 == counts)
binLocation[i]

## prob of seeing 14 or more
lambda = mean(counts[ - which.max(counts) ])
l<-(0:13)
1 - sum(dpois(l, lambda))

## qqplot to see how well  poisson describes the data
ps <- (seq(along=counts) - 0.5)/length(counts)
lambda <- mean( counts[ -which.max(counts)])
poisq <- qpois(ps,lambda)
qqplot(poisq,counts)
abline(0,1)


# Models for Variance -----------------------------------------------------

library(devtools)
install_github("genomicsclass/tissuesGeneExpression")
library(tissuesGeneExpression)
data("tissuesGeneExpression")
library(genefilter)
y = e[,which(tissue=="endometrium")]
dim(y)

dim(y)[2]

for (col in 1:dim(y)[2]) {
  print(var(y[,col]))
  qqnorm(y[,col])
}

install.packages("limma")
library(limma)

library(MASS)
fitdistr(y, 'f', start=list(df1=14, df2=14))
