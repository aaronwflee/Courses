import datetime
import re


def get_date(date_str = 'today'):

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

    if not type(date_str) == str:
        raise 'date input value needs to be string!'
        pass

    for format_item in list_formats:
        try:
            date_str = datetime.datetime.strptime(date_str, format_item).date()
            break
        except ValueError:
            continue

    if date_str == 'today':
        date_str = datetime.date.today()

    return date_str



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
    assert type(get_date()) == datetime.date
    assert get_date('01 06 1999') == datetime.date(06-01-99)

def test
