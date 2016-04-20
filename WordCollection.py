'''
WordCollection - module for a collection of words, which form a sentence.
'''

import json
import Word
from LexemeCollection import LexemeCollection

class WordCollection(LexemeCollection):

    # Concatenate words and separate them with a single space.
    def view(self, format):
        if format.lower() == 'json':
            strlist=[]
            for lex in self.lexemes:
                strlist.append(lex.get_text())
            prejson = {'lexemes' : strlist,
                        'complete' : self.complete }
            if self.key != '':
                prejson['key']=key
            if len(self.tags) > 0:
                prejson['tags'] = self.tags
            prejson['foo']='bar'
            return json.dumps(prejson)
        else:
            raise ValueError('Must specify a valid format!')

    # Construct this from a JSON object/dictionary.
    def import_json(self, jsonobj):
        print jsonobj
        print jsonobj['_id']
        self.lexemes = []
        for lexStr in jsonobj['lexeme']:
            self.lexemes.append(Word.Word(lexStr))
        self.complete = jsonobj['complete']
        if 'tags' in jsonobj:
            self.tags = jsonobj['tags']
        if 'key' in jsonobj:
            self.key = jsonobj['key']
