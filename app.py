from flask import Flask
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps

app = Flask(__name__)
mongo = PyMongo(app)

@app.route('/view')
def api_view_sentences:
    return mongo.db.sentences.find({'complete':True})

@app.route('/')
def home_page():
    mongo.db.users.insert({"online": True})
    test = mongo.db.users.find({'online':True})
    return dumps(test)

if __name__ == '__main__':
    app.run(debug=True)
