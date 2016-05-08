'''
SentenceCollection - module for a collection of sentences, which form a paragraph.
The concrete class of the Template in the Template Design Pattern
'''

from SentenceCraftApp import Sentence
from SentenceCraftApp.LexemeCollection import LexemeCollection

class SentenceCollection(LexemeCollection):
    '''
    Implementation of the abstract base Lexeme Collection
    '''
    # Construct this from a JSON object/dictionary.
    def import_json(self, jsonobj):
        self.lexemes = []
        for lex_str in jsonobj['lexemes']:
            self.lexemes.append(Sentence.Sentence(lex_str))
        self.complete = jsonobj['complete']
        if 'tags' in jsonobj:
            self.tags = jsonobj['tags']
