mylist = range(1, 6)             # [1, 2, 3, 4, 5]

### 6.4 Doubling lists

# list comprehension
mydoubled1 = [x*2 for x in mylist]
#print mydoubled1
# map()
mydoubled2 = map(lambda x: x * 2, mylist)
#print mydoubled2


### 6.5 Filter for more than 2
# list comprehension
morethantwo1 = [x for x in mylist if x > 2]
#print morethantwo1
# filter()
morethantwo2 = filter(lambda x: x > 2, mylist)
#print morethantwo2


### 6.6 Sum up values
# list comprehension
sum1 = sum([x for x in mylist]) # inefficient since we could just do sum(mylist)
#print sum1
sum2 = reduce(lambda x,y: x+y, mylist)
#print sum2


### 6.7 Average
# couldn't figure out how to do this

### 6.8 Factorial
fact = reduce(lambda x,y: x*y, mylist)
print fact
