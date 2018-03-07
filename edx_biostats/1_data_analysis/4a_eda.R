library(dplyr)
library(downloader)
library(rafalib)
library(UsingR)
library(ggplot2)
setwd("/Users/aaronwflee/Documents/biostats_courses/1_data_analysis/")

# see if data is normally distributed ----------------------------------------------------------------------
## set up plotting environment to do 3X3 plots
par(mfrow=c(3,3))
## qqplot for each of the nine columns
for (i in 1:9) {
  qqnorm(dat[,i])
}

# exploring non-normal/outlying data ----------------------------------------------------------------------
## use example of insecticide study data
str(InsectSprays)
table(InsectSprays$spray)

par(mfrow=c(1,1))
boxplot(split(InsectSprays$count, InsectSprays$spray))
## or
boxplot(InsectSprays$count~InsectSprays$spray)

## use example of NYC marathon data
data(nym.2002, package="UsingR")
str(nym.2002)

## see boxplot
boxplot(nym.2002$time~nym.2002$gender)

## see if the distributions are similar, if they are normal, what the skew is, etc.
par(mfrow=c(1,2))
hist(filter(nym.2002, gender =='Male')$time)
hist(filter(nym.2002, gender =='Female')$time)

## check means
mean(filter(nym.2002, gender =='Male')$time)
mean(filter(nym.2002, gender =='Female')$time)



# scatterplot and stratifying data -------------------------------------------------------------

## NOTES
## stratify data to plot boxplots
## use split to get categories of each whole number in series x
boxplot(split(y, round(x)))
## get the exact mean of a particular group
mean(y[round(x) == 72])
## we can also standardize x and y (z-score) and the slope will be the correlation

data(nym.2002, package="UsingR")

## split into male and female
males <- filter(nym.2002, gender == 'Male')
females <- filter(nym.2002, gender == 'Female')

## check correlation of age and finishing time for these groups
cor.test(males$time, males$age)
cor.test(females$time, females$age)

## visual inspection of overall sample
qplot(ceiling(nym.2002$age/5)*5, nym.2002$time)
boxplot(split(nym.2002$time, ceiling(nym.2002$age/5)*5))
boxplot(split(nym.2002$time, ceiling(nym.2002$age/10)*10))


# Log ratios --------------------------------------------------------------

## fastest time
time = sort(nym.2002$time)
## slowest time
time[length(time)]/median(time)

##plotting linearly
plot(time/median(time), ylim=c(1/4,4))
abline(h=c(1/2,1,2))

##plotting the log
##use log for data with outliers/exponential increase
plot(log2(time/median(time)),ylim=c(-2,2))
abline(h=-1:1)