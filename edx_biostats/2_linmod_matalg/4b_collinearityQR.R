sex <- factor(rep(c("female","male"),each=4))
trt <- factor(c("A","A","B","B","C","C","D","D"))

X <- model.matrix( ~ sex + trt)
qr(X)$rank

Y <- 1:8

## where X[,2] is sexmale and X[,5] is treatment D
makeYstar <- function(a,b) Y - X[,2] * a - X[,5] * b

fitTheRest <- function(a,b) {
  Ystar <- makeYstar(a,b)
  Xrest <- X[,-c(2,5)]
  betarest <- solve(t(Xrest) %*% Xrest) %*% t(Xrest) %*% Ystar
  residuals <- Ystar - Xrest %*% betarest
  sum(residuals^2)
}

## get the SS when male and treatment D coef is 2
fitTheRest(1,2)


## create a grid of values, e.g
expand.grid(1:3,1:3)

betas = expand.grid(-2:8,-2:8)
rss = apply(betas,1,function(x) fitTheRest(x[1],x[2]))
min(rss)



# QR Decomposition --------------------------------------------------------

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/spider_wolff_gorb_2013.csv"
filename <- "spider_wolff_gorb_2013.csv"
library(downloader)
if (!file.exists(filename)) download(url, filename)
spider <- read.csv(filename, skip=1)

fit <- lm(friction ~ type + leg, data=spider)

betahat <- coef(fit)

Y <- matrix(spider$friction, ncol=1)
X <- model.matrix(~ type + leg, data=spider)

QR <- qr(X)
(betahat <- solve.qr(QR, Y))

Q <- qr.Q( QR )
R <- qr.R( QR )
R[1,1]

(betahat <- backsolve(R, crossprod(Q,Y) ) )

