import sys
import os

try:
    filedir = sys.argv[1]
    print os.listdir(filedir)
except OSError:
    exit('File directory not valid! try again')

if len(sys.argv[:]) > 1:
    try:
        criteria, order = sys.argv[2:]
    except ValueError:
        exit('Needs three arguments: directory, criteria, order')

if criteria not in set(['name', 'size', 'mtime']) or order not in set(['ascending', 'descending']):
    print 'criteria or order not valid! try again'
else:
    print 'Your directory "{}"    sorted by {}    in an {} order'.format(filedir, criteria, order)


home = {}

for item in os.listdir(filedir):

    item_path = os.path.join(filedir, item)

    if os.path.isdir(item_path):
        home[item] = {}
        for sub_item in os.listdir(item_path):
            sub_item_path = os.path.join(item_path, sub_item)
            if os.path.isfile(sub_item_path):
                home[item][sub_item] = {'name': os.path.basename(sub_item), 'size': os.path.getsize(sub_item_path), 'mtime': os.path.getmtime(sub_item_path)}

    elif os.path.isfile(item_path):
        home[item] = {'name': os.path.basename(item), 'size': os.path.getsize(item_path), 'mtime': os.path.getmtime(item_path)}

    else:
        print 'ERROR: item is neither file nor folder'


slist = sorted(home, key = lambda arg: home[arg][criteria])
print slist
