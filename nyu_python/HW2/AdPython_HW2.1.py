import os
import sys

sendmail_prog = '/usr/sbin/sendmail'   # mac default.  use
                                       # 'which sendmail' to locate

required_args = set(['to', 'from'])
valid_args = set(['to', 'from', 'subject', 'body'])

args = sys.argv[1:]
print args

print

mail_dict = {}
for i in args:
    key, value = i.split('=')
    mail_dict[key] = value

if len(required_args.difference(mail_dict.keys())) > 0:
    print "Missing argument:", required_args.difference(mail_dict.keys()), "TRY AGAIN"
if len(set(mail_dict.keys()).difference(valid_args)) > 0:
    print "Invalid argument:", set(mail_dict.keys()).difference(valid_args)
print


header = '''
From: {}
To: {}
Subject: {}
'''.format(mail_dict['from'], mail_dict['to'], mail_dict['subject'])

print header

msg = header + mail_dict['body']
sendmail = os.popen(sendmail_prog + " -t", "w")
sendmail.write(msg)
sendmail.close()
