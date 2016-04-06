"""
SentenceCraft API
"""
import uuid
from flask import Flask
from flask import request
from flask import render_template
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps

APP = Flask("app")
MONGO = PyMongo(APP)

# To manually insert sentences into the database
# > mongo
# > use app
# > db.sentences.insert({"content": "Illuminati confirmed."
#                "complete": true})

# To insert from a file
# > "mongo < insert-sentences.txt"

@APP.route('/view-sentences/')
def api_view_sentences():
    """
    returns a list of count sentences
    from a GET http request
    """
    count = request.args.get('count')
    if count is None:
        count = '10'

    try:
        i_count = int(count)
    except ValueError:
        i_count = 10

    sentences = MONGO.db.sentences.find({'complete':True}).sort("_id", -1).limit(i_count)
    return 'Your count was '+count+' '+dumps(sentences)

@APP.route('/incomplete-sentence/')
def api_get_incomplete_sentence():
    """
    returns a singular incomplete sentence
    from a GET http request
    """
    sentence = MONGO.db.sentences.find_one({'complete':False})
    try:
        key = sentence['key']
        return 'The key was: {0}'.format(key) + dumps(sentence)
    except KeyError:
        return "ERROR: no key found"

@APP.route('/start-sentence/', methods=['POST'])
def api_start_incomplete_sentence():
    """
    endpoint for inserting an
    incomplete sentence into the database
    via POST http request
    """
    sentence_start = request.form["sentence_start"]
    words = sentence_start.split(' ')
    key = uuid.uuid4()
    MONGO.db.sentences.insert({"words": words, "complete": False, "key": key})
    return sentence_start

@APP.route('/view-HTML/')
def view_html_sample():
    """
    endpoint for viewing sentences in the database
    """
    sentences = MONGO.db.sentences.find()
    return render_template('index.html', sentences=sentences)

if __name__ == '__main__':
    APP.run(debug=True)
