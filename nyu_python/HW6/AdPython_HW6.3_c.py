import os

def list_filename(folder):
    files = []
    try:
        os.listdir(folder)
    except OSError:
        exit('File directory not valid! try again')

    for item in os.listdir(folder):
        item_path = os.path.join(folder, item)

        if os.path.isfile(item_path):
            files.append(os.path.basename(item))

        elif os.path.isdir(item_path):
            files.append([os.path.basename(item), os.listdir(item_path)])
            list_filename(files[-1])

    for each_item in files:
        yield each_item



my_files = list_filename('NYU')
while True:
    print my_files.next()

exit()
