#### verifying normal distribution allows us to make standard inferences about our data
#### the qq (quantile) plot plots percentiles of data against normal distribution -- straight diagonal = normal
#### if normal, we can also convert data (standardize) i.e. Z-scores/standard deviations

library(dplyr)
library(downloader)
library(rafalib)


# Normal Distribution -----------------------------------------------------

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleControlsPopulation.csv"
filename <- basename(url)
download(url, destfile=filename)
x <- unlist( read.csv(filename) ) ## x is the weight of all mice

set.seed(1)

## get mean weight of 5 mice 5000 times
avg_5 = vector("numeric", length=1000)
for (i in 1:1000) {
  avg_5[i] <- mean(sample(x, 5))
}

## get mean weight of 50 mice 5000 times
avg_50 = vector("numeric", length=1000)
for (i in 1:1000) {
  avg_50[i] <- mean(sample(x, 50))
}

hist(avg_5)
hist(avg_50)

## get proportion of avg_50 betw 23 and 25
mean(abs(avg_50 >= 23 & avg_50 <= 25))


pnorm(25, 23.9, 0.43) - pnorm(23, 23.9, 0.43)


# Populations vs Samples --------------------------------------------------

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/mice_pheno.csv"
filename <- basename(url)
download(url, destfile=filename)
dat <- read.csv(filename) 
dat <- na.omit( dat )

## save M & chow diet mice weights as vector
mc_weight <- filter(dat, Sex=='M' & Diet=='chow')$Bodyweight %>% unlist

## get mean
mean(mc_weight)
## calculate population SD with rafalib (different from native sd function)
popsd(mc_weight)

set.seed(1)
## get sample weight where n = 25
mean(sample(mc_weight, 25))


## save M & hf diet mice weights as vector
mh_weight <- filter(dat, Sex=='M' & Diet=='hf')$Bodyweight %>% unlist

## get mean
mean(mh_weight)
## calculate population SD with rafalib (different from native sd function)
popsd(mh_weight)

set.seed(1)
## get sample weight where n = 25
mean(sample(mh_weight, 25))


## sample diff
34.768 - 32.0956
## pop diff
(34.768 - 32.0956) - (34.84793 - 30.96381)


## save F & chow diet mice weights as vector
fc_weight <- filter(dat, Sex=='F' & Diet=='chow')$Bodyweight %>% unlist
## save M & hf diet mice weights as vector
fh_weight <- filter(dat, Sex=='F' & Diet=='hf')$Bodyweight %>% unlist
## get population mean difference
pop_diff = abs(mean(fc_weight) - mean(fh_weight))


## get sample weight where n = 25
set.seed(1)
sc_1 <- mean(sample(fc_weight, 25))
## get sample weight where n = 25
set.seed(1)
sc_2 <- mean(sample(fh_weight, 25))
## get sample mean difference
sam_diff = abs(sc_1 - sc_2)

sam_diff - pop_diff


# Central limit theorem ---------------------------------------------------

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/mice_pheno.csv"
filename <- basename(url)
download(url, destfile=filename)
dat <- na.omit( read.csv(filename) )


## get weights of male controls
y <- filter(dat, Diet=='chow' & Sex=='M')$Bodyweight %>% unlist
## save the mean and sd
msd <- mean(y)
ysd <- popsd(y)
## proportion within 1 SD
mean(abs(y > msd - ysd & y < msd + ysd))
## proportion within 2 SD
mean(abs(y > msd - 2*ysd & y < msd + 2*ysd))
## proportion within 3 SD
mean(abs(y > msd - 3*ysd & y < msd + 3*ysd))

## qq plot for four different conditions
mypar(2,2)
y <- filter(dat, Sex=="M" & Diet=="chow") %>% select(Bodyweight) %>% unlist
z <- ( y - mean(y) ) / popsd(y)
qqnorm(z);abline(0,1)
y <- filter(dat, Sex=="F" & Diet=="chow") %>% select(Bodyweight) %>% unlist
z <- ( y - mean(y) ) / popsd(y)
qqnorm(z);abline(0,1)
y <- filter(dat, Sex=="M" & Diet=="hf") %>% select(Bodyweight) %>% unlist
z <- ( y - mean(y) ) / popsd(y)
qqnorm(z);abline(0,1)
y <- filter(dat, Sex=="F" & Diet=="hf") %>% select(Bodyweight) %>% unlist
z <- ( y - mean(y) ) / popsd(y)
qqnorm(z);abline(0,1)

## look at random variable
set.seed(1)
y <- filter(dat, Sex=="M" & Diet=="chow") %>% select(Bodyweight) %>% unlist
avgs <- replicate(10000, mean( sample(y, 25)))
mypar(1,2)
hist(avgs)
qqnorm(avgs)
qqline(avgs)
mean(avgs)
sd(avgs)


# t-test ------------------------------------------------------------------
library(downloader)
url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleMiceWeights.csv"
filename <- "femaleMiceWeights.csv"
if(!file.exists("femaleMiceWeights.csv")) download(url,destfile=filename)
dat <- read.csv(filename)

p = 1/6
n = 100

set.seed(1)
z = replicate(10000, (mean( sample(1:6, size=n, replace=TRUE) ==6) - p) / sqrt(p*(1-p)/n))
mean(abs(z)>2)

X <- filter(dat, Diet=="chow") %>% select(Bodyweight) %>% unlist
Y <- filter(dat, Diet=="hf") %>% select(Bodyweight) %>% unlist

mean(X)
sd(X)

##z score
z = 2/sd(X)*sqrt(12)
1 - (pnorm(z) - pnorm(-z))
## alternatively
2 * ( 1-pnorm(2/sd(X) * sqrt(12) ) )

## standard error (where 12 is the N )
se = sqrt( var(X)/12 + var(Y)/12 )

## get t-statistic
tstat <- (mean(X) - mean(Y))/se 

## calculate likelihood of seeing this T-statistic given normal distribution
righttail <- 1 - pnorm(abs(tstat)) 
lefttail <- pnorm(-abs(tstat))
pval <- lefttail + righttail
print(pval)