library(dplyr)
library(downloader)
library(rafalib)
setwd("/Users/aaronwflee/Documents/biostats_courses/1_data_analysis/")

# Monte Carlo -------------------------------------------------------------

## write function to calculate the t-statistic given a normally distributed sample of size n
mc1 <- function(n) {
  x <- rnorm(n, mean = 0, sd = 1)
  X <- mean(x); sd <- sd(x)
  t <- (sqrt(5)*X)/sd
  return(t)
}

set.seed(1)
## run the function 1000 times with sample size of 5
mc1_t <- replicate(1000, mc1(5))
## get the proportion with T > 2
mean(mc1_t > 2)

## randomly generate quantiles from ~0 to ~1
B=100; ps = seq(1/(B+1), 1-1/(B+1),len=B)
## plot our earlier function t-scores against the theoretical t-scores (using quantiles from line above)
qqplot(qt(ps,df=4), replicate(100, mc1(1000)))


## test t-statistic for random equal distributions against theoretical t-scores
B=1000; ps = seq(1/(B+1), 1-1/(B+1),len=B)
N = 100
tscores <- replicate(1000, t.test(rnorm(N), rnorm(N), var.equal = TRUE)$stat)
qqplot(qt(ps,df=2*N-2), tscores)

## t-statistics for binary distributions
set.seed(1)
N <- 15
B <- 10000
tstats <- replicate(B,{
  X <- sample(c(-1,1), N, replace=TRUE)
  sqrt(N)*mean(X)/sd(X)
})
ps=seq(1/(B+1), 1-1/(B+1), len=B) 
qqplot(qt(ps,N-1), tstats, xlim=range(tstats))
abline(0,1)
#The population data is not normal thus the theory does not apply.
#We check with a Monte Carlo simulation. The qqplot shows a large tail. 
#Note that there is a small but positive chance that all the X are the same.
##In this case the denominator is 0 and the t-statistics is not defined


## t-statistics for binary distributions
set.seed(1)
N <- 1000
B <- 10000
tstats <- replicate(B,{
  X <- sample(c(-1,1), N, replace=TRUE)
  sqrt(N)*mean(X)/sd(X)
})
ps=seq(1/(B+1), 1-1/(B+1), len=B) 
qqplot(qt(ps,N-1), tstats, xlim=range(tstats))
abline(0,1)


## approximating distributions
mean(replicate(1000, abs(median(rnorm(1000)) > 0.001))) ## ~ 0.5
mean(replicate(1000, abs(median(rnorm(1000, 0, 1/sqrt(1000)))) > 0.001)) ## ~ 0.97


# Permutations ------------------------------------------------------------

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/babies.txt"
filename <- basename(url)
download(url, destfile=filename)
babies <- read.table("babies.txt", header=TRUE)
bwt.nonsmoke <- filter(babies, smoke==0) %>% select(bwt) %>% unlist 
bwt.smoke <- filter(babies, smoke==1) %>% select(bwt) %>% unlist

## take samples of 10 from each condition
N=10
set.seed(1)
nonsmokers <- sample(bwt.nonsmoke , N)
smokers <- sample(bwt.smoke , N)

## get a mean difference
obs <- mean(smokers) - mean(nonsmokers)
obs_med <- median(smokers) - median(nonsmokers)
## alternately, we can simply combine and shuffle the samples
## and see if two random draws from this shuffled sample yield the same magnitude of difference
dat <- c(smokers,nonsmokers)
set.seed(1)
shuffle <- function(measure) {
  shuffle <- sample( dat )
  smokersstar <- shuffle[1:N]
  nonsmokersstar <- shuffle[(N+1):(2*N)]
  measure(smokersstar)-measure(nonsmokersstar)
}

null <- replicate(1000, shuffle(mean))

1 - mean(abs(obs) > abs(null))

null <- replicate(1000, shuffle(median))
1 - mean(abs(obs_med) > abs(null))



# Association and chi sq test ---------------------------------------------
d = read.csv("assoctest.csv")
table(d)
## chi square test
chisq.test(table(d))
## fisher test
fisher.test(table(d))
