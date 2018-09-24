import datetime
import re

list_formats = ['%m/%d/%y', '%m/%d/%Y', '%B/%d/%y', '%B/%d/%Y', '%b/%d/%y',
    '%b/%d/%Y', '%d/%m/%Y', '%d/%m/%y', '%d/%B/%y', '%d/%B/%Y', '%d/%b/%y',
    '%d/%b/%y', '%Y/%m/%d', '%Y/%d/%m', '%y/%m/%d', '%y/%d/%m',

    '%m-%d-%y', '%m-%d-%Y', '%B-%d-%y', '%B-%d-%Y', '%b-%d-%y', '%b-%d-%Y',
    '%d-%m-%Y', '%d-%m-%y', '%d-%B-%y', '%d-%B-%Y', '%d-%b-%y',
    '%d-%b-%y', '%Y-%m-%d', '%Y-%d-%m', '%y-%m-%d', '%y-%d-%m',

    '%m.%d.%y', '%m.%d.%Y', '%B.%d.%y', '%B.%d.%Y', '%b.%d.%y',
    '%b.%d.%Y', '%d.%m.%Y', '%d.%m.%y', '%d.%B.%y', '%d.%B.%Y', '%d.%b.%y',
    '%d.%b.%y', '%Y.%m.%d', '%Y.%d.%m', '%y.%m.%d', '%y.%d.%m',

    '%m %d %y', '%m %d %Y', '%B %d %y', '%B %d %Y', '%b %d %y',
    '%b %d %Y', '%d %m %Y', '%d %m %y', '%d %B %y', '%d %B %Y', '%d %b %y',
    '%d %b %y', '%Y %m %d', '%Y %d %m', '%y %m %d', '%y %d %m',

    '%m/%d %y', '%m/%d %Y', '%B/%d %y', '%B/%d %Y', '%b/%d %y', '%b/%d %Y',
    '%d/%m %Y', '%d/%m %y', '%d/%B %y', '%d/%B %Y', '%d/%b %y', '%d/%b %y']


def get_date(date_str = 'today'):

    for format_item in list_formats:
        try:
            d_date = datetime.datetime.strptime(date_str, format_item).date()
            break
        except ValueError:
            continue

    if date_str == 'today':
        d_date = datetime.date.today()

    try:
        print d_date
        return d_date
    except UnboundLocalError:
        print 'Wrong Format entered'


def add_day(date, num_days=1):
    change = datetime.timedelta(days=num_days)
    return date + change


def format_date(date, date_format='default'):
    df = date_format.lower()

    df = re.sub('month', '%B', df)
    df = re.sub('mon', '%b', df)
    df = re.sub('mm', '%m', df)
    df = re.sub('dd', '%d', df)
    df = re.sub('yyyy', '%Y', df)
    df = re.sub('yy', '%y', df)

    if df == 'default':
        df = '%Y-%m-%d'

    rep = {'mm':'%m', 'mon':'%b', 'month':'%B', 'dd': '%d', 'yy':'%y', 'yyyy':'%Y'}

    return datetime.date.strftime(date, df)


#dt = get_date() #test get_date

#dt_3daysago = add_day(dt, -3) #test add_day

#print format_date(dt_3daysago) #test format_date

def main(): # put all my functions into main()
    get_date()
    add_day()
    format_date()

if __name__ == '__main__':
    main()
