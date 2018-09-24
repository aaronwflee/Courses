city = set([])
country = {}
domains = {}

i = 0
for line in open('/Users/aaronwflee/Desktop/NYU/HW2/bitly.tsv'):
    if i == 0:
        i += 1
        continue

    line.rstrip('\n')
    els = line.split('\t')

    # unique domains
    longurl = els[4].rsplit('/')
    url = longurl[2]
    if url in domains:
        domains[url] += 1
    else:
        domains[url] = 1

    # unique cities
    if els[5] not in city:
        city.add(els[5])

    # unique countries
    if els[6] in country:
        country[els[6]] += 1
    else:
        country[els[6]] = 1

print sorted(city)


c = sorted(country, key=country.get)
print c[-10:]

d = sorted(domains, key=domains.get)
print d[-10:]
