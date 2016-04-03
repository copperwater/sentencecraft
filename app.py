from flask import Flask
from flask import request # lets us access request parameters
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps
import uuid

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
    sentence = mongo.db.sentences.find_one({'complete':False})    
    try:
        key = sentence['key']
        return 'The key was: {0}'.format(key) + dumps(sentence)
    except:
        return "ERROR: no key found"

@app.route('/start-sentence/', methods =['POST'])
def api_start_incomplete_sentence():
    sentence_start =request.form["sentence_start"]
    words = sentence_start.split(' ')
    key = uuid.uuid4()
    mongo.db.sentences.insert({"words": words, "complete": False, "key": key})
    return sentence_start
    #TODO enforce the schema
    #return errors if stuff goes wrong

@app.route('/view-HTML/')
def view_HTML_sample():
    sentences = mongo.db.sentences.find()
    return flask.render_template('index.html', sentences = sentences)

if __name__ == '__main__':
    app.run(debug=True)
