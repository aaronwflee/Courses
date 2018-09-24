import pickle

class Guestbook(object):

    def __init__(self, id):
        self.id = id
        self.entries = []
        self.index = -1

    def add_entry(self, entry):
        self.entries.append(entry)

    def __iter__(self):
        return self

    def next(self):
        self.index += 1
        if self.index > len(self.entries) - 1:
            raise StopIteration
        return self.entries[self.index]

    def store(self, newfile):
        fh = open(newfile+'.pickle', 'w')
        pickle.dump(self, fh)
        fh.close()


class Entry(object):
    def __init__(self, name, comment):
        from datetime import datetime
        self.date = datetime.now()
        self.name = name
        self.comment = comment

guestbook_id = '1'
guestbook = Guestbook(guestbook_id)    # unpickles existing Guestbook with
                                       # pickle.dump() or creates new
entry = Entry('David', 'I like it!')   # populates an Entry object attrs
                                       # .name, .comment, .date
guestbook.add_entry(entry)             # adds object to internal list
guestbook.add_entry(Entry('Aaron', 'Not bad'))


guestbook.store('NYU/HW8/guestbook/data/guestbook')                      # Guestbook object pickles itself

import pickle
f = open('NYU/HW8/guestbook/data/guestbook.pickle')
print type(f)
gb = pickle.load(f)
print type(gb)

for entry in gb:
    print '{} said {} on {}'.format(entry.name,
                                    entry.comment,
                                    entry.date)
