# fibonacci sequence

import sys
print 'fibonacci sequence up to number'.format(sys.argv[1])

i = 2
new = 0
x = 1
y = 1
print x,
print y,
while new < int(sys.argv[1]):
    if new != 0:
        print new,
    new = x + y
    x = y
    y = new
    i += 1


print '\nThere are {} numbers in the fibonacci sequence below {}'.format(i, sys.argv[1])
