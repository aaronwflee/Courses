import sys
import urllib2

print sys.argv
weather_web = urllib2.urlopen('https://www.wunderground.com/history/airport/{}/{}/1/1/CustomHistory.html?dayend=31&monthend=12&yearend={}&format=1'.format(sys.argv[1], sys.argv[2], sys.argv[2]))
text = weather_web.readlines()


total = 0  # create var for running total for meanTemperature
high = -1000.  # set an outrageously high temperature so the next meanTemperature will be highest
low = 1000.  # set an outrageously low temperature so the next meanTemperature will be lowest
i = 0  # counter for number of days
for line in text[2:]:
    line_st = line.strip()
    cell = line_st.split(',')
    if float(cell[2]) > high:  # check if temp is higher than current record
        high = float(cell[2])
    if float(cell[2]) < low:  # check if temp is lower than current record
        low = float(cell[2])
    total += float(cell[2])  # save to running total
    i += 1
mean = total/(i)  # divide sum of temperature by number of days

v = 0  # create var for variance
j = 0  # counter for number of days
for line in text[2:]:
    line_st = line.strip()
    cell = line_st.split(',')
    v += (float(cell[2]) - mean) ** 2  # add to running total of variance
    j += 1
sd = (v/j)**0.5  # calculate SD from variance/# of days


print 'mean:', mean
print 'min:', low
print 'max:', high
print 'SD:', sd
