'''
WordCollection - module for a collection of words, which form a sentence.
'''

import json
from LexemeCollection import LexemeCollection

class WordCollection(LexemeCollection):

    # Abstract function instantiations
    def __init__(self, firstlex, tagList):
        LexemeCollection.__init__(self, firstlex, tagList)

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
                prejson['tags'] = tags
            return json.dumps(prejson)
        else:
            raise ValueError('Must specify a valid format!')
