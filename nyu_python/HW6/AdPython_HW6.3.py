'''
Write a recursive function that takes a directory and prints out all files and directories beneath it
        (i.e. in the tree of directories listed within this directory).
    The function's main purpose is to list a directory that is passed to it,
        but when it encounters a directory it should again call itself with that new directory.

Next, write the function so that it accumulates the files and dirs encountered in a list
(it will need to pass this list between recursive calls) and returns the list at the end.

Lastly, write the function as a generator that yields its values instead of printing or returning them.

Super extra credit:  can such an object be written as a class?  I'm not sure!
'''

import os

def list_filename(folder):
    files = []
    try:
        for item in os.listdir(folder):
            item_path = os.path.join(folder, item)

            if os.path.isfile(item_path):
                files.append(os.path.basename(item))

            elif os.path.isdir(item_path):
                files.append([os.path.basename(item), os.listdir(item_path)])
                list_filename(files[-1])

        for each_item in files:
            yield each_item

    except OSError:
        exit('File directory not valid! try again')

my_files = list_filename('NYU')
for i in range(100):
    print '{}:'.format(i), my_files.next()

exit()
