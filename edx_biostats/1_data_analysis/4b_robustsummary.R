library(dplyr)
library(downloader)
library(rafalib)
library(UsingR)
library(ggplot2)
setwd("/Users/aaronwflee/Documents/biostats_courses/1_data_analysis/")


# Intro to Robust Summaries -----------------------------------------------

## median is more resistant to outliers than mean
x <- c(rnorm(99), 100)
mean(x) # = 0.9744152
median(x) # = 0.09459293

## likewise, MAD is a more robust measure of spread than std dev
sd(x) # = 10.06019
## MAD is the median of absolute deviations from the median
mad <- function(y) {
  median_list <- c()
  for (value in y) {
    median_list <- c(median_list, abs(value-median(x)))
  }
  median(median_list)
}
mad(x) # = 0.7073603

## for correlations, spearman's is more robust than pearson's
## because it uses rank
y <- rnorm(100)
cor(sort(x), sort(y), method="pearson")
cor(sort(x), sort(y), method="spearman")


# Reshape & Robust Summaries ----------------------------------------------

# get dataset
data(ChickWeight)


head(ChickWeight)
plot( ChickWeight$Time, ChickWeight$weight, col=ChickWeight$Diet)

chick = reshape(ChickWeight, idvar=c("Chick","Diet"), timevar="Time",
                direction="wide")
chick = na.omit(chick)
rownames(chick) <- NULL

## weight on fourth day + an outlier
w4 <- chick$weight.4
w4o <- c(chick$weight.4, 3000)

## average weight increases by 2.06 times with outlier
mean(w4o)/mean(w4)
## median weight doesn't change with outlier
median(w4o)/median(w4)


## Standard deviation and MAD
sd(w4o)/sd(w4) ## 101.29
mad(w4o)/mad(w4) ## 1

## now look at correlation

w21 <- c(chick$weight.21)
w21o <- c(chick$weight.21, 3000)

cor(w4o, w21o, method="pearson")/cor(w4, w21, method="pearson")



# mann whitney wilcox -----------------------------------------------------

x <- filter(chick, Diet == 1)$weight.4
y <- filter(chick, Diet == 4)$weight.4


## t-test and more robust wilcox test
t.test(x,y)
wilcox.test(x,y)

## add outlier to y
x <- c(x, 200)
t.test(x,y)$p.value
wilcox.test(x,y)$p.value



## downsides of mann-whitney-wilcox
mypar(1,3)
boxplot(x,y)
boxplot(x,y+10)
boxplot(x,y+100)


t.test(x,y+10)$statistic - t.test(x,y+100)$statistic
wilcox.test(x,y+10)$statistic - wilcox.test(x,y+100)$statistic

wilcox.test(c(1,2,3),c(4,5,6))
wilcox.test(c(1,2,3),c(400,500,600))
