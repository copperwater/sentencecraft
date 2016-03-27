from flask import Flask
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps

app = Flask("app")
mongo = PyMongo(app)


# To manually insert sentences into the database
# > mongo
# > use app
# > db.sentences.insert({"content": "Illuminati confirmed."})

# To insert from a file
# > "mongo < insert-sentences.txt"

# View the API endpoint
# > python app.py
# > 127.0.0.1:5000/view-sentences

@app.route('/view-sentences/')
def home_page():
    test = mongo.db.sentences.find()
    return dumps(test)

if __name__ == '__main__':
    app.run(debug=True)
