import pandas as pd

# read in data
df = pd.read_csv('F-F_Research_Data_Factors_daily.txt', skiprows=5, skipfooter=2, sep='\s+',
                                                        names=['date', 'MktRF', 'SMB', 'HML', 'RF'], engine='python')

# create new variable for year
df['year'] = df.date.apply(lambda x: str(x)[0:4])

# get mean
df_avg = df.groupby('year')['MktRF'].mean()
# test
print df_avg['1993']

# get median
def median(df):
    s_list = sorted(list(df['MktRF']))
    return s_list[len(s_list)/2]

df_med = df.groupby('year').apply(median)
print df_med['2010']

###########################################################################
# if using dict of lists                                                  #
###########################################################################

import sys

FF = 'F-F_Research_Data_Factors_daily.txt'
mydict = {}

for line in open(FF).readlines()[6:-2]:
    items = line.split()
    this_year = items[0][0:4]
    if this_year not in mydict:
        mydict[this_year] = []
    mydict[this_year].append(float(items[1]))


def avgMktRF(year):
    print 'avg for {}: {}'.format(year, sum(mydict[year]) /
                                    len(mydict[year]))

avgMktRF('2008')
