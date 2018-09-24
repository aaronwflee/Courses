import flask
import pickle

app = flask.Flask(__name__)      # a Flask object

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
        fh = open('data/'+newfile+'.pickle', 'w')
        pickle.dump(self, fh)
        fh.close()


class Entry(object):
    def __init__(self, name, comment):
        from datetime import datetime
        self.date = datetime.now()
        self.name = name
        self.comment = comment


@app.route('/display_entries')            # called when visiting web URL 127.0.0.1:5000/
def display_entries():
    fh = open('data/guestbook.pickle')
    gb = pickle.load(fh)
    return flask.render_template('guestbook.html', guestbook=gb)

@app.route('/add_entry')
def add_entry():
    guestbook = pickle.load(open('data/guestbook.pickle'))

    n = flask.request.args.get('name')
    com = flask.request.args.get('comment')                                   # pickle.dump() or creates new

    guestbook.add_entry(Entry(n, com))             # adds object to internal list
    guestbook.store('guestbook')                      # Guestbook object pickles itself

    return flask.redirect(flask.url_for('display_entries', msg='Updated!'))

if __name__ == '__main__':
    app.run(debug=True, port=5000)    # app starts serving in debug mode on port 5000
