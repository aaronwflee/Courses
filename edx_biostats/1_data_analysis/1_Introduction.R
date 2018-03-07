library(dplyr)
## read in data
dat <- read.csv("femaleMiceWeights.csv", header=TRUE)
## get column names
names(dat)

## index from dataset given row and column number
dat[12,2]
## index from specific columns
dat$Bodyweight[11]

## get mean of rows with hf
length(dat$Bodyweight)
mean(dat[13:24,]$Bodyweight)
## sample 1 from dataset
set.seed(1)
sample(dat[13:24, ]$Bodyweight, 1)


## dplyr functions -- filter rows, select columns, vectorize (unlist)
ctrl <- filter(dat, Diet=="chow")
ctrl <- select(ctrl, Bodyweight)
ctrl <- unlist(ctrl)

## dplyr piping
controls <- filter(dat, Diet=='chow') %>% 
  select(Bodyweight) %>% 
  unlist



# Sleep -------------------------------------------------------------------

library(downloader)
url="https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv"
filename <- basename(url)
download(url,filename)

sleep <- read.csv(filename)
names(sleep)
class(sleep)

nrow(filter(sleep, order=='Primates'))
class(filter(sleep, order=='Primates'))

mean(filter(sleep, order=='Primates') %>% select(sleep_total) %>% unlist)

filter(sleep, order=="Primates") %>% summarise( mean( sleep_total))
