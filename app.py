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
from Sentence import Sentence
from SentenceCollection import SentenceCollection
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

@APP.route('/view-sentences/', methods=['GET', 'POST'], strict_slashes=False)
def api_view_sentences():
    """
    returns a list of count sentences
    from a GET http request
    """

    # extract the count parameter (number of LCs to display)
    count = request.args.get('count')
    if count is None:
        count = 10
    try:
        count = int(count)
    except ValueError:
        count = 10

    # extract the type parameter (type of lexeme)
    typ_param = request.args.get('type')
    if typ_param == 'sentence':
        typ = 'sentence'
        db_collection = MONGO.db.paragraphs
    else:
        #default is Word
        typ = 'word'
        db_collection = MONGO.db.sentences

    # extract the tag list parameter, if any
    try:
        tags=request.form['tags'].split(',')
        if(len(tags) == 1 and tags[0] == ''):
            tags = []
    except: # TODO: What type of exception is this?
        tags=[]

    # query the database for complete lexeme collections
    # using an AND of all provided tags
    if (len(tags) != 0):
        LCs = db_collection.find({"$and": [{'complete':True},
            {'tags': {"$all" :tags} }]}).sort("_id", -1).limit(count)
    else:
        LCs = db_collection.find({'complete':True}).sort("_id", -1).limit(count)

    # Convert the database results to the appropriate LexemeCollection objects
    # then construct a list of their JSON views
    json_list = []
    for LC_bson_object in LCs:
        if typ == 'word':
            lc = WordCollection()
        elif typ == 'sentence':
            lc = SentenceCollection()

        lc.import_json(LC_bson_object)
        json_list.append(lc.view('json'))

    return json.dumps(json_list), 200


@APP.route('/incomplete-sentence/', methods=['GET'], strict_slashes=False)
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
        return 'ERROR: No incomplete sentences are available.', 503
        # 503 Service Unavailable

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

    return json.dumps(prejson), 200

@APP.route('/complete-sentence/', methods=['POST'], strict_slashes=False)
def api_complete_sentence():
    """
    endpoint for completing an incomplete sentence based on a key
    """
    try:
        sentence_addition = request.form["sentence_addition"]
        key = request.form["key"]
        complete = request.form["complete"]
    except: # TODO: figure out and except the specific error here
        return "ERROR: key or sentence_addition is missing", 400

    if complete == 'true':
        complete = True
    else:
        complete = False

    # check that the key is not timed out
    if not key in LC_MAP:
        return "ERROR: This sentence has timed out", 408

    # get the document in the database
    to_complete = MONGO.db.sentences.find_one({"key":key})
    if to_complete is None:
        # this should never happen
        return 'ERROR: No sentence matching your key was found in the db', 400

    '''
    TODO: This segment of code is an absolute mess.
    It needs: limiting the lexemes to 1, validating it as a normal or ending
    lexeme appropriately, and not just blindly slapping it on to_complete.
    '''

    # import into a WordCollection

    # get the last lexeme as a Word
    #final_lexeme = Word(sentence_addition.split(' ')[-1])

    # make sure it is a valid ending lexeme
    #if not final_lexeme.is_valid_end():
    #    return 'ERROR: '+final_lexeme.get_text()+' is not a valid ending '+final_lexeme.type(),400

    to_complete['lexemes']= to_complete['lexemes'] + (sentence_addition.split(' '))

    wc = WordCollection()
    wc.import_json(to_complete)

    # validate it
    if not wc.validate():
       return 'ERROR: The overall sentence is not valid', 400

    # update the document as being complete and remove the key
    MONGO.db.sentences.update(
        {"_id": to_complete['_id']},
        {'$set':
            {"complete":complete, "lexemes":wc.view("string"), "key":""}}, upsert = False)

    # remove it from the timeout list
    del LC_MAP[key]

    # return 200 OK
    return "Successfully completed the sentence", 200

@APP.route('/start-sentence/', methods=['POST'], strict_slashes=False)
def api_start_incomplete_sentence():
    """
    endpoint for inserting an incomplete sentence into the database
    via POST http request
    """
    print "Received new sentence api CALL"
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
        return "ERROR: "+first_lexemes[0]+" is not a valid beginning", 400
    for lex in first_lexemes[1:]:
        curr_lex = Word(lex)
        if not curr_lex.is_valid():
            return "ERROR: "+first_lexemes[0]+" is not valid", 400

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

# Run this once and only in one thread. Note that it will not run until the
# first request comes in; it will not run automatically at startup.
@APP.before_first_request
def single_thread_setup():
    # Start a new thread for polling
    threading.Thread(None, poll_for_expired).start()


if __name__ == '__main__':
    APP.run(debug=True, host=config.flask_host, port=config.flask_port)
