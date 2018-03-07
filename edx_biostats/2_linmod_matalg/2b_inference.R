library(dplyr)
library(downloader)
library(rafalib)
library(UsingR)
library(ggplot2)
setwd("/Users/aaronwflee/Documents/biostats_courses/2_linmod_matalg/")
par(mfrow=c(1,1))

## gravity example

g = 9.8 ## meters per second
h0 = 56.67
v0 = 0
n = 25
tt = seq(0,3.4,len=n) ##time in secs, t is a base function
y = h0 + v0 *tt - 0.5* g*tt^2 + rnorm(n,sd=1)
plot(y)

## act as if we didn't know h0, v0 and -0.5*g

## y = h0 + v0 *tt - 0.5* g*tt^2 + rnorm(n,sd=1)
## y = b0 + b1 *tt + b2*tt^2 + e
## to obtain least square estimates:
X = cbind(1,tt,tt^2)
A = solve(crossprod(X))%*%t(X)

## so given observations in y, g is equal to
2 * (A %*% y) [3]

## random generation to see SD of g estimate
set.seed(1)
g = replicate(100000, -2 * (A %*% (h0 + v0 *tt - 0.5* g*tt^2 + rnorm(n,sd=1)))[3])
sd(g)


## father and son heigh example
x = father.son$fheight
y = father.son$sheight
n= length(y) ## number of rows in dataset

## get random indices (rows to pull)
set.seed(1)
fsbeta <- function() {
  index = sample(n,50)
  sampledat = father.son[index,]
  x= sampledat$fheight
  y= sampledat$sheight
  betahat = lm(y~x)$coef[2]
}

betas <- replicate(10000, fsbeta())
sd(betas)


# variance covariance matrix to get std error of betas----------------------------------------------

##################################
## SUMMARY
## 1. calculate sum of squared residuals
## 2. calculate sigma^2 by dividing 1 by (N - nterms)
## 3. create identity matrix -- first column all 1's, second column is predictor (x)
## 4. multiply sigma^2 by the diagonal of the inverse of identity matrix cross product
## 5. first term is the std error of the intercept, the rest are the std error of slopes
##################################

## get covariance of the father's and son's height
## covariance is the average of the two deviations' product
## mean( (Y - mean(Y))*(X-mean(X) ) )
mean( (y - mean(y)) * (x - mean(x)) )


## getting the linear combination of estimates
## use this to get standard error of beta estimates

x = father.son$fheight
y = father.son$sheight

set.seed(1)
index = sample(length(y),50)

sampledat = father.son[index,]
x = sampledat$fheight
y = sampledat$sheight

## get fitted values (i.e. predicted)
fit = lm(y ~ x)
fit$fitted.values

## sum of squared residuals
SSR = sum( (y - fit$fitted.values)^2 )

## sigma squared (variance of Y) is SSR/(N-nterms) or 48
## N = 50 and nterms is 2 (intercept, slope1)
sigma2 = SSR/48

## make design matrix
## first column is all 1 (identity matrix) and second column is father's height
X = cbind(rep(1, N), x)
## calculate (t(X) %*% X)^-1
design_matrix <- solve(crossprod(X))


## get standard error of intercept and beta-hat
sqrt(diag(design_matrix)*sigma2)