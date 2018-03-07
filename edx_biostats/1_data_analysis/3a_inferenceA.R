library(dplyr)
library(downloader)
library(rafalib)


# Inference ---------------------------------------------------------------

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/babies.txt"
filename <- basename(url)
download(url, destfile=filename)
babies <- read.table("babies.txt", header=TRUE)

## We will study the differences in birth weight between babies born to smoking and non-smoking mothers.

summary(babies)

bwt.nonsmoke <- filter(babies, smoke == 0) %>% select(bwt) %>% unlist
bwt.smoke <- filter(babies, smoke == 1) %>% select(bwt) %>% unlist

mean(bwt.nonsmoke) - mean(bwt.smoke)
popsd(bwt.nonsmoke)
popsd(bwt.smoke)

## We will treat the babies dataset as the full population and draw samples from it to simulate individual experiments.
## We will then ask whether somebody who only received the random samples would be able to draw correct conclusions about the population.

set.seed(1)

dat.ns <- sample(bwt.nonsmoke, 25)
dat.s <- sample(bwt.smoke, 25)

##calculate std error (sqrt of difference in var/N)
se = sqrt(var(dat.ns)/25+var(dat.s)/25)
##calculate t-statistic (mean diff divided by SE)
tstat <- (mean(dat.ns) - mean(dat.s))/se
##confirm t-stat
t.test(dat.ns, dat.s)

## to get the probability of observing this T-statistic
1-pnorm(abs(tstat)) + pnorm(-abs(tstat))
## or
2*pnorm(-abs(tval))


# Confidence intervals ----------------------------------------------------

## get the z-score multiplier for 99% 
Q <- qnorm(1- 0.01/2)
## multiply that by the standard error
Q*se


## with t-distribution
set.seed(1)
dat.ns <- sample(bwt.nonsmoke, 25)
dat.s <- sample(bwt.smoke, 25)


T <- qt(c(.005, .995), df=46)[2]
T*se

set.seed(1)
sdat.ns <- sample(bwt.nonsmoke, 5)
sdat.s <- sample(bwt.smoke, 5)

t.test(sdat.s, sdat.ns)


# Power -------------------------------------------------------------------

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/babies.txt"
filename <- basename(url)
download(url, destfile=filename)
babies <- read.table("babies.txt", header=TRUE)

bwt.nonsmoke <- filter(babies, smoke==0) %>% select(bwt) %>% unlist 
bwt.smoke <- filter(babies, smoke==1) %>% select(bwt) %>% unlist

mean(bwt.nonsmoke)-mean(bwt.smoke)
popsd(bwt.nonsmoke)
popsd(bwt.smoke)

set.seed(1)

## test power of sample size 5
rejections <- replicate(10000, t.test(sample(bwt.nonsmoke, 5), sample(bwt.smoke, 5))[3] < 0.05)
mean(rejections)

## test power of other sample sizes
for (n in seq(30, 120, by = 30)) {
  rejections <- replicate(10000, t.test(sample(bwt.nonsmoke, n), sample(bwt.smoke, n))[3] < 0.05)
  print(mean(rejections))
}

## test power of those sample sizes if the alpha level is 0.01
for (n in seq(30, 120, by = 30)) {
  rejections <- replicate(10000, t.test(sample(bwt.nonsmoke, n), sample(bwt.smoke, n))[3] < 0.01)
  print(mean(rejections))
}
