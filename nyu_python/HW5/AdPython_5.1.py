class Logger(object):
    loglevel = {'DEBUG':5,'INFO':4,'WARNING':3,'ERROR':2,'CRITICAL':1}
    s = '  '
    n = '\n'

    def __init__(self, filename, priority, logtime=True, scriptname=True):
        try:
            self.file = open(filename, 'a')
        except IOError, e:
            print 'File cannot be opened'
            exit()

        try:
            self.priority = priority.upper()
            self.p = Logger.loglevel[self.priority]
        except ValueError, e:
            print 'Not a valid priority level'
            exit()
        except KeyError, e:
            print 'Not a valid priority level'
            exit()

        if logtime:
            import datetime
            self.logtime = datetime.datetime.now()
        else:
            self.logtime = ''

        if scriptname:
            import sys
            import os
            self.scriptname = os.path.basename(sys.argv[0])
        else:
            self.scriptname = ''

    def write(self, log_message):
        eval("self.file.write(str(self.logtime) + Logger.s + str(self.scriptname) + Logger.s + log_message + Logger.n)")

    def critical(self, log_message):
        if self.p > 0:
            Logger.write(self, log_message)

    def error(self, log_message):
        if self.p > 1:
            Logger.write(self, log_message)

    def warning(self, log_message):
        if self.p > 2:
            Logger.write(self, log_message)

    def info(self, log_message):
        if self.p > 3:
            Logger.write(self, log_message)

    def debug(self, log_message):
        if self.p > 4:
            Logger.write(self, log_message)

    def save(self):
        self.file.close()


x = Logger('testlog.txt', 'INFO', False, False)
x.critical('this is a critical test log')
x.debug('also a debug test')
x.info('less than debug but still detailed')
x.save()

'''

    def towrite(self, log_message):
        return self.logtime + log_message + '\n'

    def critical(self, log_message):
        if self.p > 0:
            Logger.towrite(log_message)

'''
