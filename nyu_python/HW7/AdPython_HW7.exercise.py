match_strings = [
    'hello world 00',
    'goodbye world    ',
    ' 23 bonjour',
    'wilkommen23  ',
    'aloha',
    '99',
    '88557799',
    'Que 3 Tal!',
    'myfile.jpg',
    'yourfile.JPG'
]

import re


def regex(pattern, criteria, neg = False, stringlist = match_strings):
        for string in stringlist:
            if neg == False:
                if re.search(pattern, string):
                    print string, criteria
            else:
                if not re.search(pattern, string):
                    print string, criteria

## 7.1
regex(r'\d', 'contains digits')


## 7.1
regex(r'\d', 'contains digit')

## 7.2
regex(r'^\d', 'starts with digit')

## 7.3
regex(r'\d$', 'ends with digit')

## 7.4
regex(r'^\d\d$', 'is exactly 2-digit number')

## 7.5
regex(r'^\d+$', 'is exactly one or more digits')

## 7.6
regex(r'^\d+$', 'has non-digit character', 'no')

## 7.7
regex(r'\d', 'contains only non-digits', 'no')

## 7.8
regex(r'\w[a-zA-Z]+', 'contains one or more letters')

## 7.9
regex(r'^\w+$', 'contains word characters')

## 7.10
regex(r'^\w[a-zA-Z]+$', 'contains only letters')

## 7.11
regex(r'[A-Z]', 'contains capital letter') # why is this different from r'\w[A-Z]'

## 7.12
regex(r'\s\s$', 'has two-space at end')

## 7.13
regex(r'\w', 'has non-space characters')

## 7.14
regex(r'\s', 'has only non-space characters', 'no')

## 7.15
regex(r'\d$', 'has non-digit last character', 'no')

## 7.16
regex(r'^[a-zA-Z]+$', 'has only non-space characters', 'no')

## 7.17
regex(r'\w[a-zA-Z]\d', 'has letter-digit pair')

## 7.18
regex(r'\w\.', 'has word character followed by period')

## 7.19
regex(r'\w+\s+\w+', 'has at least two words')

## 7.20
regex(r'\.(jpg|JPG)$', 'ends with .jpg')

## 7.21
for string in match_strings:
    if re.search(r'\.jpg$', string, re.IGNORECASE):
        print string, 'ends with .jpg'

## 7.22
regex(r'\d', 'has no digits', 'no')
