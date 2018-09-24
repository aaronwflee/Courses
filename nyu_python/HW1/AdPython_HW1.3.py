upper = int(input('Please enter max integer:'))

for num in range(2, upper):
    prime = 1
    for div in range(2, 100):
        if num != div:
            if num % div == 0:
                prime = 0
                break
    if prime == 1:
        print num
