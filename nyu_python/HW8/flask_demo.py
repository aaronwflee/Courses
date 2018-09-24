import flask
my_app = flask.Flask(__name__)      # a Flask object

@my_app.route('/')            # called when visiting web URL 127.0.0.1:5000/
def hello_world():
    return 'What is your <A HREF="/bye"> name</A>'

@my_app.route('/bye')         # called when visiting web URL 127.0.0.1:5000/bye
def goodbye():
    fname = flask.request.args.get('fname')              # like dict.get()
    lname = flask.request.values['lname']                # like dict access
    return 'fname: {}, lname: {}'.format(fname, lname)

if __name__ == '__main__':
    my_app.run(debug=True, port=5000)    # app starts serving in debug mode on port 5000
