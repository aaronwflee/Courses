# Random Distributions ------------------------------------------------

library(dplyr)

## read in experiment data
dat <- read.csv("femaleMiceWeights.csv")

## use dplyr to create vectors for the bodyweights in each condition
controls <- filter(dat, Diet=='chow') %>% select(Bodyweight) %>% unlist # mean is 23.8
treatment <- filter(dat, Diet=='hf') %>% select(Bodyweight) %>% unlist # mean is 26.8
obs <- mean(treatment) - mean(controls)

## read in population data to compare
population <- read.csv("femaleControlsPopulation.csv")

#population <- unlist(population)
#m = 0
#for (i in seq(1,100)) {
#  m = m + mean(sample(population, 12))
#}
#print(m/100)

## take a sample of 5 mice and compare their average weight to population average
set.seed(1)
PopM <- mean(population$Bodyweight)
SamM <- mean(sample(population$Bodyweight, 5))
abs(PopM - SamM)

## take a sample of 5 mice and compare their average weight to population average
set.seed(5)
PopM <- mean(population$Bodyweight)
SamM <- mean(sample(population$Bodyweight, 5))
abs(PopM - SamM)

# Null Distributions ------------------------------------------------

population <- unlist(population)

## initialize for loop
n <- 10000
means <- vector("numeric", n)
## taking random sample from population, how often will we get a result like the experiment we observed
for (i in 1:n) {
  fake_controls <- sample(population, 12)
  fake_treatment <- sample(population, 12)
  means[i] <- mean(fake_treatment) - mean(fake_controls)
}
mean(means)
max(means) 
hist(means) 

## generate p-value
## i.e. percent of cases where random difference is more than observed difference
mean(abs(means > obs)) ## p = 0.012


set.seed(1)
n = 1000
means <- vector("numeric", n)
for (i in 1:n) {
  means[i] <- mean(sample(population, 50))
}
mean(abs(means - PopM) > 1)


# Probability Distribution ------------------------------------------------
install.packages("gapminder")
library(gapminder)
data(gapminder)
head(gapminder)

ss <- filter(gapminder, year == 1952)$lifeExp
mean(abs(ss <= 60 & ss >= 40))


## custom function to calculate proportion
prop = function(q) {
  mean(x <= q)
}

qs = seq(from=min(1), to=max(100), length=20)
props = sapply(qs, prop)
plot(qs, props)

### or ###

props = sapply(qs, function(q) mean(x <= q))
