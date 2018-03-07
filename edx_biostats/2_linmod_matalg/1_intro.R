library(dplyr)
library(downloader)
library(rafalib)
library(UsingR)
library(ggplot2)
setwd("/Users/aaronwflee/Documents/biostats_courses/2_linearm_matrix_algebra/")

data("father.son",package="UsingR")

## get average sons' heights
head(father.son)
mean(father.son$sheight)

## get average sons' of 71 in fathers heights
mean(filter(father.son, round(fheight) == 71)$sheight)

## create matrix using matrix()
X = matrix(1:1000,100,10)
X[25,3]
## create matrix using matrix (horizontally)
X = matrix(1:60,20,3,byrow=TRUE)
X[,3]

## create matrix using cbind
x=1:10
X = cbind(x, x*2, x*3, x*4, x*5)
sum(X[7,])


## which of the following do not return X?
t(t(X)) ## DOES, transposes transpose
X %*% matrix(1,ncol(X) ) ## NOT
X *1 ## DOES, returns matrix * 1 = matrix
X%*%diag(ncol(X)) ## DOES, multiplying identity matrix returns original

## solve equations using matrices

#3a + 4b - 5c + d = 10
#2a + 2b + 2c - d = 5
#a -b + 5c - 5d = 7
#5a + d = 4
X <- matrix(c(3, 2, 1, 5, 4, 2, -1, 0, -5, 2, 5, 0, 1, -1, -5, 1),4,4)
Y <- matrix(c(10, 5, 7, 4), 4, 1)
print(solve(X)%*%Y)


## matrix multiplication
a <- matrix(1:12, nrow=4)
b <- matrix(1:15, nrow=3)
ab <- a%*%b
## get specific element (3rd row, 2nd column)
ab[3,2]

## element multiplication
## get the sum of product of 3rd row in a and 2nd column in b
sum(a[3,]*b[,2])