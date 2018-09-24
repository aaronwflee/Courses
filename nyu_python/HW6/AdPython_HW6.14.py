lines = open('student_db.txt').readlines()[1:]

### 6.10: writing to file

# map
new = open('new_db.txt', 'w')
map(new.write, lines)

# list comprehension
new2 = open('new2_db.txt', 'w')
[new2.write(i) for i in lines]

### 6.11: writing only ID to file

#map
id1 = open('id1_db.txt', 'w')
map(id1.write, lines.split(':')[0]) # this returns an error, not sure how to do it

# list comprehension
id2 = open('id2_db.txt', 'w')
[id2.write(i.split(':')[0] + ' ') for i in lines]


### 6.12 dict of ID to zip
# using dict comprehension
lines = open('student_db.txt').readlines()[1:]
zipdict = {line.split(':')[0]: line.split(':')[4].rstrip('\n') for line in lines}
print zipdict


### 6.13
wanted_lines = open('FF_abbreviated.txt').readlines()
print sum([float(line.split('    ')[1]) for line in wanted_lines])

wanted_year = '1981'

### 6.14

# using list comprehension
file_lines = open('HW6/F-F_Research_Data_Factors_daily.txt').readlines()
wanted_lines = file_lines[6:-2]
print sum([float(line.split()[1]) for line in wanted_lines if '1981' in line.split()[0]])

# using reduce()

file_lines = open('F-F_Research_Data_Factors_daily.txt').readlines()
wanted_lines = file_lines[6:-2]
wanted_year = '1981'
mktrfsum = reduce(lambda a,x: a + x, [float(x.split()[1]) for x in wanted_lines if x.startswith(wanted_year)])
print mktrfsum
