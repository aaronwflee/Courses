import datetime

class Timestamp(object):
    import datetime
    def __init__(self):
        self.t = datetime.datetime.now()
    def get_time(self):
        return self.t

now =  Timestamp()
print now.get_time()


class ThisClass(object):
    def report(self):
        print id(self)
        return id(self)

class Square(object):
    def __init__(self):
        self.int = 2
    def squareme(self):
        self.int = self.int * self.int
    def getme(self):
        return self.int

n1 = Square()
n2 = Square()
n3 = Square()

n1 = Square()
n1.squareme()
print n1.getme()
print n2.getme()
print n3.getme()


n2.squareme()
n2.squareme()
print n1.getme()
print n2.getme()
print n3.getme()

for i in range(10):
    n3.squareme()

print n1.getme()
print n2.getme()
print n3.getme()

n4 = Square()

print n4.getme()
n4.squareme()
print n4.getme()
