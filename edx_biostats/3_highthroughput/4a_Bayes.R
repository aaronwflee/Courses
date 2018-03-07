library(dplyr)
library(ggplot2)
# Bayes rule --------------------------------------------------------------

## P(Incident | Positive test) = P(Positive test | Incident) * P(Incident)
## / P(Positive) i.e.  P(Incident)*P(Positive test | Incident) +  P(No Incident)*P(Positive test | No Incident)
## we are weighting by the likelihood of the disease independent of test

## p(A|B) = P(B|A)*P(A) / (P(A) * P(B|A) + P(!A)*P(B|*A)
p_ba = 0.99
p_bna = 1 - 0.99
p_a = 0.00025
p_na = 1 - p_a
p_ab = (p_ba * p_a) / ((p_a * p_ba) + (p_na * p_bna))
p_ab ## explanation: proportion of people who actually have disease 
## within group of people who test positive is so small

## in practice: apply to baseball batting averages
## need hierarchical model - first level is player variability and second level is luck
## continuous version of bayes rule with F (parametric) distribution

## formula
## B(league average) + (1-B)(player data)
## where B is luck / (luck + player variability)
## so if luck is a huge part of overall variance, B is large/close to 1
## hence we weight B(league average) very heavily. If luck is small, B is small, 
## i.e. player skill is more important, we weight player data heavily


tmpfile <- tempfile()
tmpdir <- tempdir()
download.file("http://seanlahman.com/files/database/lahman-csv_2014-02-14.zip",tmpfile)
##this shows us files
filenames <- unzip(tmpfile,list=TRUE)
players <- read.csv(unzip(tmpfile,files="Batting.csv",exdir=tmpdir),as.is=TRUE)
unlink(tmpdir)
file.remove(tmpfile)

## get averages for players with more than 500 bats in 2012
filter(players,yearID==2012) %>% mutate(AVG=H/AB) %>% filter(AB>=500) %>% select(AVG)
## get average and standard deviation for players from 2010 - 2012
mean(filter(players, (yearID==2012|yearID==2011|yearID==2010)) %>% mutate(AVG=H/AB)  %>% filter(AB>=500) %>% select(AVG) %>% unlist())
sd(filter(players, (yearID==2012|yearID==2011|yearID==2010)) %>% mutate(AVG=H/AB)  %>% filter(AB>=500) %>% select(AVG) %>% unlist())

AVG <-filter(players, (yearID==2012|yearID==2011|yearID==2010)) %>% mutate(AVG=H/AB) %>% filter(AB>=500)  %>% select(AVG) %>% unlist() 
qplot(AVG)
qqnorm(AVG)
qqline(AVG)

## get standard deviation of bernoulli trials (sqrt(np(1-p)))
sd = sqrt((0.45*0.55)/20)
sd

## get estimate using prior and variances
B = 0.11^2/(0.11^2 + 0.027^2)
exp = B*0.275 + (1-B)*0.45
exp


# Hierarchical models in practice -----------------------------------------

library(rafalib)
install_bioc("SpikeInSubset")
source("https://bioconductor.org/biocLite.R")
biocLite("SpikeInSubset")
library(SpikeInSubset)
data(rma95)
y <- exprs(rma95)

## artificial RNA added
pData(rma95)
## index of whether artificial data was added
spike <- rownames(y) %in% colnames(pData(rma95))
## factor
g <- factor(rep(0:1,each=3))


library(genefilter)
## run t-test
pval <- (rowttests(y, g)$p.value)
## save indices for which are significant
pval_bool <- pval < 0.01
## calculate % (not artificial & signif) / (signif)
sum(pval_bool & !spike)/ sum(pval_bool)

## look at SDs of all possible outcome types
sds <- rowSds(y[,g==0])
index <- paste0( as.numeric(spike), as.numeric(pval<0.01))
index <- factor(index,levels=c("11","01","00","10"),labels=c("TP","FP","TN","FN"))
boxplot(split(sds,index))

##don't have package limma available
install.packages("limma")
library(limma)
fit <- lmFit(y, design=model.matrix(~ g))
colnames(coef(fit))
fit <- eBayes(fit)

sampleSD = fit$sigma
posteriorSD = sqrt(fit$s2.post)


library(limma)
fit = lmFit(y, design=model.matrix(~ g))
fit = eBayes(fit)
##second coefficient relates to diffences between group
pvals = fit$p.value[,2] 

source("http://www.bioconductor.org/biocLite.R")
biocLite("SpikeInSubset")
library(SpikeInSubset)
data(mas133)
e <- exprs(mas133)
plot(e[,1],e[,2],main=paste0("corr=",signif(cor(e[,1],e[,2]),3)),cex=0.5)
k <- 3000
b <- 1000 #a buffer
polygon(c(-b,k,k,-b),c(-b,-b,k,k),col="red",density=0,border="red")

## what proportion are within the lower left hand corner box
mean(e[,1] <3000 & e[,2] <3000)

## log transform to get better view
plot(log2(e[,1]),log2(e[,2]),main=paste0("corr=",signif(cor(log2(e[,1]),log2(e[,2])),2)),cex=0.5)
k <- log2(3000)
b <- log2(0.5)
polygon(c(b,k,k,b),c(b,b,k,k),col="red",density=0,border="red")

## get MA plot
e <- log2(exprs(mas133))
plot((e[,1]+e[,2])/2,e[,2]-e[,1],cex=0.5)

sd(e[,2]-e[,1])

sum(abs(e[,2]-e[,1])>1)
