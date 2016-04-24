"""
SentenceCraft API
"""

# Standard modules
import uuid
import sched
import threading
import time
import sys
import json

# Tech stack modules
from flask import Flask
from flask import request
from flask import render_template
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps

# Local SentenceCraft modules
import Word
from Word import Word
from WordCollection import WordCollection
import SentenceCraftConfig as config

APP = Flask("app")
MONGO = PyMongo(APP)

# Set up the dictionary of keys to lexeme collections
# This will be a map of UUID strings to 2-tuples. The first element will
# be the lexeme collection, the second will be the timestamp in seconds at
# which it was created.
LC_MAP = {}

'''
 API functions that are not special Flask functions (without an @ directive).
'''

def check_out():
    '''
    Put the LexemeCollection into the LC_MAP with a newly generated UUID
    and timestamp. Then return the uuid.
    '''
    new_uuid = str(uuid.uuid4())
    new_uuid = 'w'
    stamp = int(time.time())
    LC_MAP[new_uuid] = stamp
    return new_uuid


def poll_for_expired():
    '''
    Check to see if any active LexemeCollections have been in LC_MAP longer than
    the limit in SentenceCraftConfig. If they are, remove them.
    '''
    while True: #continue this indefinitely
        for key in list(LC_MAP):
            if (int(time.time()) - LC_MAP[key]) > config.lexeme_collection_active_time:
                del LC_MAP[key]
                print 'Timeout'
        time.sleep(config.polling_delay)

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
    json_list = []
    for sentence in sentences:
        wc = WordCollection()
        wc.import_json(sentence)
        json_list.append(wc.view('json'))
    #return 'Your count was '+count+' ' + jsonStr
    return json.dumps(json_list)


@APP.route('/incomplete-sentence/')
def api_get_incomplete_sentence():
    """
    returns a single incomplete sentence from a GET http request
    """
    sentence = MONGO.db.sentences.find_one(
        {'complete':False,
         '$or': [
            {'key' : {'$exists': False}},
            {'key' : ""}]
        })

    # make sure there was really a sentence
    if sentence is None:
        return 'ERROR: No incomplete sentences are available.'

    lc = WordCollection()
    lc.import_json(sentence)

    # check out and generate a key for this sentence
    key = check_out()

    # mark the sentence in the db as active (by giving it its key), so other
    # requests won't get the same sentence
    MONGO.db.sentences.update({'_id': sentence['_id']},
                              {'$set': {'key': key}},
                              upsert=False)

    prejson = {
        'lexemecollection': lc.view('json'),
        'key': key
    }

    return json.dumps(prejson)

@APP.route('/complete-sentence/', methods=['POST'])
def api_complete_sentence():
    """
    endpoint for completing an incomplete sentence based on a key
    """
    try:
        sentence_addition = request.form["sentence_addition"]
        key = request.form["key"]
    except: # TODO: figure out and except the specific error here
        return "ERROR: key or sentence_addition is missing"

    # check that the key is not timed out
    if not key in LC_MAP:
        return "ERROR: This sentence has timed out"

    # get the document in the database
    to_complete = MONGO.db.sentences.find_one({"key":key})
    if to_complete is None:
        # this should never happen
        return 'ERROR: No sentence matching your key was found in the db'

    # import into a WordCollection
    wc = WordCollection()
    wc.import_json(to_complete)

    # get the last lexeme as a Word
    final_lexeme = Word(sentence_addition.split(' ')[0])

    # make sure it is a valid ending lexeme
    if not final_lexeme.is_valid_end():
        return 'ERROR: '+final_lexeme.get_text()+' is not a valid ending '+final_lexeme.type()

    wc.append(final_lexeme, True)

    # validate it
    if not wc.validate():
        return 'ERROR: The overall sentence is not valid'

    # update the document as being complete and remove the key
    MONGO.db.sentences.update(
        {"_id": to_complete['_id']},
        {'$set':
            {"complete":True, "lexemes":wc.lexemes_as_stringlist(), "key":""}}, upsert = False)

    # remove it from the timeout list
    del LC_MAP[key]

    # return 200 OK
    return "Successfully completed the sentence", 200

@APP.route('/start-sentence/', methods=['POST'])
def api_start_incomplete_sentence():
    """
    endpoint for inserting an incomplete sentence into the database
    via POST http request
    """
    # Set the tags variable correctly
    # The assumption is that tags will not contain a ','
    try:
        tags = request.form["tags"].split(',')
    except:
        tags = []

    # Get the starting list of lexemes
    # Possible TODO: make sure this is capped at some value
    first_lexemes = request.form['sentence_start'].split(' ')

    # Construct them as Lexemes and validate them
    curr_lex = Word(first_lexemes[0])
    if not curr_lex.is_valid_beginning:
        return "ERROR: "+first_lexemes[0]+" is not a valid beginning"
    for lex in first_lexemes[1:]:
        curr_lex = Word(lex)
        if not curr_lex.is_valid():
            return "ERROR: "+first_lexemes[0]+" is not valid"

    # Insert into the database
    MONGO.db.sentences.insert(
        {"lexemes": first_lexemes, "complete": False, "tags":tags})

    # return 200 OK
    return "Successfully started the sentence", 200

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

# Run this once and only in one thread. Note that it will not run until the
# first request comes in; it will not run automatically at startup.
@APP.before_first_request
def single_thread_setup():
    # Start a new thread for polling
    threading.Thread(None, poll_for_expired).start()


if __name__ == '__main__':
    APP.run(debug=True)
