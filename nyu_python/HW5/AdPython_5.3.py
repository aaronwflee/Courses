class DatetimeSimple(object):
    all_formats = ['%m/%d/%y', '%m/%d/%Y', '%B/%d/%y', '%B/%d/%Y', '%b/%d/%y',
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

    def __init__(self, date_str='today'):
        import datetime
        self.format = '%m-%d-%Y'

        for format_item in DatetimeSimple.all_formats:
            try:
                d_date = datetime.datetime.strptime(date_str, format_item).date()
                break
            except ValueError:
                continue

        if date_str == 'today':
            d_date = datetime.date.today()

        try:
            self.date = d_date
        except UnboundLocalError:
            print 'Wrong Format entered'
            exit()

    def __sub__(self, n):
        import datetime
        change = datetime.timedelta(days=n)
        self.date = self.date - change
        return self.date

    def __add__(self, n):
        import datetime
        change = datetime.timedelta(days=n)
        self.date = self.date + change
        return self.date

    def set_format(self, date_format='default'):
        import re
        df = date_format.lower()

        df = re.sub('month', '%B', df)
        df = re.sub('mon', '%b', df)
        df = re.sub('mm', '%m', df)
        df = re.sub('dd', '%d', df)
        df = re.sub('yyyy', '%Y', df)
        df = re.sub('yy', '%y', df)

        if df == 'default':
            df = '%m-%d-%Y'

        if df in DatetimeSimple.all_formats:
            self.format = df

    def __repr__(self):
        import datetime
        return datetime.date.strftime(self.date, self.format)

    def daterange(self, interval=7, repeat=3):
        import datetime

        days = [self.date]
        f_days = [datetime.date.strftime(self.date, self.format)]

        for eachrepeat in range(repeat):
            newdate = days[-1] + datetime.timedelta(days=interval)
            days.append(newdate)
            f_days.append(datetime.date.strftime(days[-1], self.format))

        return f_days

dts = DatetimeSimple('today')
print dts
dts.set_format('dd Mon YY')
for date_str in dts.daterange(interval=7):
    print date_str
