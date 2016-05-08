'''
WordCollection - module for a collection of words, which form a sentence.
This is the concrete class of the Template for the Template design pattern
'''

from SentenceCraftApp import Word
from SentenceCraftApp.LexemeCollection import LexemeCollection

class WordCollection(LexemeCollection):
    '''
    Implementation of the abstract Lexeme collection.
    '''
    # Construct this from a JSON object/dictionary.
    def import_json(self, jsonobj):
        self.lexemes = []
        for lex_str in jsonobj['lexemes']:
            self.lexemes.append(Word.Word(lex_str))
        self.complete = jsonobj['complete']
        if 'tags' in jsonobj:
            self.tags = jsonobj['tags']
