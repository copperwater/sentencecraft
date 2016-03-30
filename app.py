from flask import Flask
from flask import request # lets us access request parameters
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps
import flask

app = Flask("app")
mongo = PyMongo(app)

# To manually insert sentences into the database
# > mongo
# > use app
# > db.sentences.insert({"content": "Illuminati confirmed." 
#                "complete": true})

# To insert from a file
# > "mongo < insert-sentences.txt"

# View the API endpoint
# > python app.py
# > 127.0.0.1:5000/view-sentences

@app.route('/view-sentences/')
def api_view_sentences():
    count = request.args.get('count')
    if (count is None): count = '10'

    try: i_count = int(count)
    except ValueError: i_count = 10 

    sentences = mongo.db.sentences.find({'complete':True}).sort("_id", -1).limit(int(count))
    return 'Your count was '+count+' '+dumps(sentences)

@app.route('/incomplete-sentence/')
def api_get_incomplete_sentence():
    sentence = mongo.db.sentences.find({'complete':False}).sort("_id", -1).limit(1)
    return dumps(sentence)

@app.route('/view-HTML')
def view_HTML_sample():
    sentences = mongo.db.sentences.find()
    return flask.render_template('index.html', sentences = sentences)

if __name__ == '__main__':
    app.run(debug=True)
