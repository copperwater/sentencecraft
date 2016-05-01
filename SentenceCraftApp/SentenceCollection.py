'''
SentenceCollection - module for a collection of sentences, which form a paragraph.
'''

import json
import Sentence
from LexemeCollection import LexemeCollection

class SentenceCollection(LexemeCollection):

    # Construct this from a JSON object/dictionary.
    def import_json(self, jsonobj):
        self.lexemes = []
        for lexStr in jsonobj['lexemes']:
            self.lexemes.append(Sentence.Sentence(lexStr))
        self.complete = jsonobj['complete']
        if 'tags' in jsonobj:
            self.tags = jsonobj['tags']
