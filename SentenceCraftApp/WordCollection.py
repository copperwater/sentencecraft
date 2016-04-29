'''
WordCollection - module for a collection of words, which form a sentence.
'''

import json
import Word
from LexemeCollection import LexemeCollection

class WordCollection(LexemeCollection):

    # Construct this from a JSON object/dictionary.
    def import_json(self, jsonobj):
        self.lexemes = []
        for lexStr in jsonobj['lexemes']:
            self.lexemes.append(Word.Word(lexStr))
        self.complete = jsonobj['complete']
        if 'tags' in jsonobj:
            self.tags = jsonobj['tags']
