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

# ??? modules
#from . import APP

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
                # remove from the map
                del LC_MAP[key]

                # because multithreading, we need to tell Flask that this is
                # happening in the same context as the rest of the app
                with APP.app_context():
                    # remove key from the database
                    # need 2 queries because Mongo can't do this across collections
                    MONGO.db.sentences.update({'key':key}, {'$unset':{'key':''}}, upsert=False)
                    MONGO.db.paragraphs.update({'key':key}, {'$unset':{'key':''}}, upsert=False)

                print 'Key',key,'timed out'

        time.sleep(config.polling_delay)

@APP.route('/view/', methods=['GET', 'POST'], strict_slashes=False)
def api_view_lexeme_collections():
    """
    returns a list of JSON lexeme collection objects
    parameters: count defines the number returned, tags is a comma-separated
    list of tags that all returned LCs must have
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

    # extract the tag list parameter, if any, and convert to a list of strings
    tags = request.args.get('tags')
    if len(tags) == 0:
        tags = []
    else:
        tags = tags.split(',')

    # query the database for complete lexeme collections
    # using an AND of all provided tags
    if len(tags) != 0:
        LCs = db_collection.find({"$and": [{'complete':True},
            {'tags': {"$all" :tags} }]}).sort("_id", -1).limit(count)
    else:
        LCs = db_collection.find({'complete':True}).sort("_id", -1).limit(count)

    # check for no results
    if LCs.count() < 1:
        return 'ERROR: No complete lexeme collections could be found', 503

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


@APP.route('/incomplete/', methods=['GET'], strict_slashes=False)
def api_get_incomplete_lexeme_collections():
    """
    returns a single incomplete lexeme collection from a GET http request
    """

    # extract the type parameter (type of lexeme)
    typ_param = request.args.get('type')
    if typ_param == 'sentence':
        typ = 'sentence'
        db_collection = MONGO.db.paragraphs
    else:
        #default is Word
        typ = 'word'
        db_collection = MONGO.db.sentences

    # select an incomplete sentence from the database
    # it must either not have a key or have an empty key string
    LC_bson = db_collection.find_one(
        {'complete':False,
         '$or': [
            {'key' : {'$exists': False}},
            {'key' : ""}]
        })

    # make sure there was really a sentence
    if LC_bson is None:
        return 'ERROR: No incomplete sentences are available.', 503
        # 503 Service Unavailable

    # construct the appropriate type of LexemeCollection and pull in the data
    # from the database query
    if typ == 'word':
        lc = WordCollection()
    elif typ == 'sentence':
        lc = SentenceCollection()
    lc.import_json(LC_bson)

    # check out and generate a key for this sentence
    key = check_out()

    # mark the sentence in the db as active (by giving it its key), so other
    # requests won't get the same sentence
    db_collection.update({'_id': LC_bson['_id']},
                         {'$set': {'key': key}},
                         upsert=False)

    # construct the object with the lexeme collection data and the key
    prejson = {
        'lexemecollection': lc.view('json'),
        'key': key
    }
    return json.dumps(prejson), 200

@APP.route('/append/', methods=['POST'], strict_slashes=False)
def api_append_to_lexeme_collection():
    """
    endpoint for continuing or completing an incomplete lexeme collection
    In order for this to work, the client must verify that it was the one who
    originally sent the request for the incomplete LC, by passing back the key
    that was sent with it.
    """
    try:
        addition = request.form["addition"]
        key = request.form["key"]
        typ_param = request.form["type"]
    except KeyError:
        return "ERROR: lexeme type, key, or addition is missing", 400

    # Separate try/except for complete because it is not a required parameter
    try:
        complete = request.form["complete"]
    except KeyError:
        complete = 'false'

    # determine whether the user is trying to continue or complete
    # defaults to continue
    if complete == 'true':
        try_to_complete = True
    else:
        try_to_complete = False

    # extract the type parameter (type of lexeme)
    if typ_param == 'sentence':
        typ = 'sentence'
        db_collection = MONGO.db.paragraphs
    else:
        #default is Word
        typ = 'word'
        db_collection = MONGO.db.sentences

    # check that the key is not timed out
    # this assumes that if the key is not in LC_MAP, it has expired
    if not key in LC_MAP:
        return "ERROR: This lexeme collection has timed out", 408

    # assume addition is one lexeme; pull it into the appropriate class
    # also make the LexemeCollection for later
    if typ == 'word':
        new_lexeme = Word(addition)
        lc = WordCollection()
    elif typ == 'sentence':
        new_lexeme = Sentence(addition)
        lc = SentenceCollection()

    # validate it as an ordinary or ending lexeme, depending on the complete
    # parameter
    if try_to_complete:
        if not new_lexeme.is_valid_end():
            return 'ERROR: '+new_lexeme.get_text()+' is not a valid ending '+new_lexeme.type(),400
    else:
        if not new_lexeme.is_valid():
            return 'ERROR: '+new_lexeme.get_text()+' is not a valid '+new_lexeme.type(),400

    # get the document in the database by the key passed in
    LC_bson_to_be_completed = db_collection.find_one({"key":key})

    if LC_bson_to_be_completed is None:
        # this should never happen
        return 'ERROR: No lexeme collection matching your key was found in the db', 500

    # get data from the query result and add in the new lexeme
    lc.import_json(LC_bson_to_be_completed)
    lc.append(new_lexeme)

    # validate it
    if not lc.validate():
        # with proper validation on all API behaviors this should never happen
        # either
       return 'ERROR: The overall lexeme collection is not valid', 400

    # update the document as being complete and remove the key
    db_collection.update(
        {"_id": LC_bson_to_be_completed['_id']},
        {'$set': {"complete":complete, "lexemes":lc.view("string")},
         '$unset': {"key": ""}},
        upsert=False)

    # remove it from the timeout list
    del LC_MAP[key]

    # return 200 OK
    return "Successfully appended to the lexeme collection", 200

@APP.route('/start/', methods=['POST'], strict_slashes=False)
def api_start_lexeme_collection():
    """
    endpoint for inserting an incomplete lexeme collection into the database
    via POST request
    """

    # Get the starting lexeme and type
    try:
        typ_param = request.form['type']
        start_str = request.form['start']
    except KeyError:
        return 'ERROR: Missing type or starting lexeme', 400

    # Get the initial tag list
    # The assumption is that individual tags cannot contain commas
    try:
        tags = request.form["tags"].split(',')
    except KeyError:
        tags = []

    # extract the type parameter (type of lexeme)
    if typ_param == 'sentence':
        typ = 'sentence'
        db_collection = MONGO.db.paragraphs
    else:
        #default is Word
        typ = 'word'
        db_collection = MONGO.db.sentences

    # Construct start_str as a Lexeme
    if typ == 'word':
        start_lex = Word(start_str)
    elif typ == 'sentence':
        start_lex = Sentence(start_str)

    # validate it as a beginning lexeme
    if not start_lex.is_valid_beginning():
        return 'ERROR: '+start_lex.get_text()+' is not a valid beginning '+start_lex.type(), 400

    # Insert into the database
    db_collection.insert(
        {"lexemes": [start_lex.get_text()], "complete": False, "tags":tags})

    # return 200 OK
    return "Successfully started the lexeme collection", 200

@APP.route('/')
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
