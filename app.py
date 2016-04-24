"""
SentenceCraft API
"""
import uuid
from flask import Flask
from flask import request
from flask import render_template
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps
import uuid
import Word
import json
from Word import Word
from WordCollection import WordCollection

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
    """
    Below line of code is for testing purpose
    """
    print "Received call from Web UI"
    count = request.args.get('count')
    if count is None:
        count = '10'
    try:
        i_count = int(count)
    except ValueError:
        i_count = 10

    sentences = MONGO.db.sentences.find({'complete':True}).sort("_id", -1).limit(i_count)
    jsonStr = ''
    for s in sentences:
        wc = WordCollection()
        wc.import_json(s)
        jsonStr += wc.view('json')
    #return 'Your count was '+count+' ' + jsonStr
    return jsonStr


@APP.route('/incomplete-sentence/')
def api_get_incomplete_sentence():
    """
    returns a singular incomplete sentence
    from a GET http request
    """
    sentence = MONGO.db.sentences.find_one({'complete':False})
    wc = WordCollection()
    wc.import_json(sentence)

    # check out and generate a key for this sentence
    wc.check_out()

    
    try:
        key = sentence['key']
        return 'The key was: {0}'.format(key) + dumps(sentence)
    except KeyError:
        return "ERROR: no key found"

@APP.route('/complete-sentence/', methods=['POST'])
def api_complete_sentence():
    """
    endpoint for completing an incomplete sentence based on a key
    """
    try:
        sentence_addition = request.form["sentence_addition"]
        key = request.form["key"]
        print "key {0}\n".format(key)
    except:
        return "ERROR: missing key/sentence_addition"
    try:
        to_complete = MONGO.db.sentences.find_one({"key":key, "complete":False})
        lexeme = to_complete["lexeme"] + sentence_addition.split(' ')
        MONGO.db.sentences.update({"_id": to_complete['_id']}, {
            '$set': {"complete":True, "lexeme":lexeme, "key":''}}, upsert = False)
        return "inserted sentence {0}".format(lexeme)
    except:
        return "ERROR invalid key\n"

@APP.route('/start-sentence/', methods=['POST'])
def api_start_incomplete_sentence():
    """
    endpoint for inserting an
    incomplete sentence into the database
    via POST http request
    """
    print "Received new sentence api CALL"
    try:
        tags = request.form["tags"]
    except:
        tags = []
    sentence_start = request.form["sentence_start"]
    lexeme = sentence_start.split(' ')
    key = uuid.uuid4()
    MONGO.db.sentences.insert({"lexeme": lexeme, "complete": False, "key": key, "tags":tags})
    print "Received API Call! Lexeme : {0}\n Tags: {1}".format(sentence_start,tags);
    MONGO.db.sentences.insert({"lexeme": lexeme, "complete": False, "key": key})
    return sentence_start

@APP.route('/view-HTML/')
def view_html_sample():
    """
    endpoint for viewing sentences in the database
    """
    print "view html"
    sentences = MONGO.db.sentences.find()
    return render_template('index.html')
	
@APP.route('/fetchdata')
def fetch_data():
    print "fetchdata"
    json_data = '{"sentences":[{"key": "123", "sentence": "First Sentence"},{"key":"124", "sentence": "Second Sentence"}]}'
    return json_data

if __name__ == '__main__':
    APP.run(debug=True)
