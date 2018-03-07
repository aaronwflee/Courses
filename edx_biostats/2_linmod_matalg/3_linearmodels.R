
library(dplyr)
library(rafalib)
library(UsingR)
library(ggplot2)
library(downloader)
library(contrast)

nx=5
ny=7
X = cbind(rep(1,nx + ny),rep(c(0,1),c(nx, ny)))

(t(X) %*% X)

(solve(t(X) %*% X))

## The element of the inverse in the 2nd row and the 2nd column is the element 
## which will be used to calculate the standard error of the second coefficient 
## of the linear model. This is:
## a / (ad - bc) 

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/spider_wolff_gorb_2013.csv"
filename <- "spider_wolff_gorb_2013.csv"
library(downloader)
if (!file.exists(filename)) download(url, filename)
spider <- read.csv(filename, skip=1)

fit <- lm(friction ~ type + leg, data = spider)
summary(fit)

## write contrast for Leg 2 vs Leg 4
L4vsL2 <- contrast(fit,list(leg="L4",type="pull"),list(leg="L2",type="pull"))
L4vsL2$X


X <- model.matrix(~ type + leg, data=spider)
(Sigma <- sum(fit$residuals^2)/(nrow(X) - ncol(X)) * solve(t(X) %*% X))
C <- matrix(c(0,0,-1,0,1),1,5)

## The off-diagonal elements of Sigma give the covariance of two different elements of the beta-hat matrix. 
##So Sigma[1,2] gives the covariance of the first and second element of beta-hat.

## linear combination of estimates is the same
L4vsL2$X %*% coef(fit)
str(fit)

## get covariance of L2 vs L4
Sigma[3,5]


# Interaction -------------------------------------------------------------



spider$log2friction <- log2(spider$friction)
boxplot(log2friction ~ type*leg, data=spider)

## linear model with interaction
fit2 <- lm(log2friction ~ type*leg, data=spider)
summary(fit2)

## run anova instead
fit2a <- aov(log2friction~type*leg, data=spider)
summary(fit2a)

## l2 vs l1 in pull (reference)
coef(fit2a)[3] 
## l2 vs l1 in push (interaction)
coef(fit2a)[3] + coef(fit2a)[6]


# ANOVA with monte carlo-------------------------------------------------------------------

## 4 groups of 10 samples
N <- 40
p <- 4
group <- factor(rep(1:p,each=N/p))
X <- model.matrix(~ group)

set.seed(1)
F <- c()
for (i in seq(1000)) {
  Y <- rnorm(N,mean=42,7)
  
  mu0 <- mean(Y)
  initial.ss <- sum((Y-mu0)^2)
  
  s <- split(Y, group)
  after.group.ss <- sum(sapply(s, function(x) sum((x - mean(x))^2)))
  
  (group.ss <- initial.ss - after.group.ss)
  group.ms <- group.ss / (p - 1)
  after.group.ms <- after.group.ss / (N - p)
  
  f.value <- group.ms / after.group.ms
  F <- c(F, f.value)
}
mean(F)


## plot
hist(F, col="grey", border="white", breaks=50, freq=FALSE)
xs <- seq(from=0,to=6,length=100)
lines(xs, df(xs, df1 = p - 1, df2 = N - p), col="red")

