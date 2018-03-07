#install.packages("devtools")
library(devtools)
#install_github("genomicsclass/GSE5859Subset")
library(GSE5859Subset)
data(GSE5859Subset) ##this loads the three tables

## check number of samples processed on certain date
head(sampleInfo)
sum(sampleInfo$date == "2005-06-27")

## see all possible chromosomes
unique(geneAnnotation$CHR)
head(geneExpression)
## count those on chromosome Y
sum(na.omit(geneAnnotation)$CHR == "chrY")


## find the log expression value of a particular gene ARPC1A in particular sample given the date 2005-06-10
## first obtain sample name from the sample info df
(f <- subset(sampleInfo, sampleInfo$date=="2005-06-10")$filename)
## next get the PROBEID of the gene
(g <- subset(geneAnnotation, geneAnnotation$SYMBOL=="ARPC1A")$PROBEID)
## extract value
geneExpression[g,f]
## use apply to get median of each column (dimension argument: 2 = column, 1 = row)
## get median of those values
median(apply(geneExpression, 2, median))


## Write a function that takes a vector of values e and a binary vector group coding two groups,
## and returns the p-value from a t-test: 
tt_p <- function(vals, group) {
  t.test(vals[group==1], vals[group==0])$p.value
}
## Now define g to code cases (1) and controls (0) 
g <- factor(sampleInfo$group)

## Next use the function apply to run a t-test for each row of geneExpression and obtain the p-value.
## What is smallest p-value among all these t-tests?
pvals <- apply(geneExpression, 1, tt_p, group=g)
min(pvals)


# Inference ---------------------------------------------------------------

set.seed(1)
library(downloader)
url = "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleControlsPopulation.csv"
filename = "femaleControlsPopulation.csv"
if (!file.exists(filename)) download(url,destfile=filename)
population = read.csv(filename)
pvals <- replicate(1000,{
  control = sample(population[,1],12)
  treatment = sample(population[,1],12)
  t.test(treatment,control)$p.val
})
head(pvals)
hist(pvals)

mean(pvals < 0.05) #0.041
mean(pvals < 0.01) #0.008

## running monte carlo simulation to test 20 diets
set.seed(100)

pvals <- replicate(20, {
  cases = rnorm(10,30,2)
  controls = rnorm(10,30,2)
  return(t.test(cases,controls)$p.value)
})
## of the 20, how many are < 0.05
sum(pvals < 0.05)

## now do this 1000 times and see the average of 20 that are significant
## set up function to record number/20 with p < 0.05
set.seed(100)
signiftest <- function() {
  test <- replicate(20, {
    cases = rnorm(10,30,2)
    controls = rnorm(10,30,2)
    t.test(cases,controls)$p.value
  })
  n <- sum(test < 0.05)
  return(n)
}
## run 1000 times
s <- replicate(1000, signiftest())

## avg number out of 2000
mean(s)

## what proportion do we say at least 1/20 is significant
sum(s > 0)/1000
