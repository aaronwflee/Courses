library(dplyr)
library(downloader)
library(rafalib)
library(UsingR)
library(ggplot2)
setwd("/Users/aaronwflee/Documents/biostats_courses/2_linmod_matalg/")


## given a matrix with two treatments, a and b
X <- matrix(c(1,1,1,1,0,0,1,1),nrow=4)
rownames(X) <- c("a","a","b","b")

## given the following betas
beta <- c(5, 2)

## calculate y
fitted = X %*% beta
fitted[1:2, ]

## now add another condition, c
X <- matrix(c(1,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,1,1),nrow=6)
rownames(X) <- c("a","a","b","b","c","c")
## with betas
beta <- c(10,3,-3)

fitted <- X %*% beta
fitted[5:6,]
