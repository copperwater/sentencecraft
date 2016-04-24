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
            '''
            Expected to return a Python dictonary that can be readily converted
            to json using json.dumps, but it should NOT be a JSON object.
            '''
            strlist=[]
            for lex in self.lexemes:
                strlist.append(lex.get_text())
            prejson = {'lexemes' : strlist,
                        'complete' : self.complete }
            if len(self.tags) > 0:
                prejson['tags'] = self.tags
            return prejson
        else:
            raise ValueError('Must specify a valid format!')

    # Construct this from a JSON object/dictionary.
    def import_json(self, jsonobj):
        self.lexemes = []
        for lexStr in jsonobj['lexemes']:
            self.lexemes.append(Word.Word(lexStr))
        self.complete = jsonobj['complete']
        if 'tags' in jsonobj:
            self.tags = jsonobj['tags']
