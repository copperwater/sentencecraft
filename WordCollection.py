'''
WordCollection - module for a collection of words, which form a sentence.
'''

import LexemeCollection

class WordCollection(LexemeCollection):

    # Abstract function instantiations
    def __init__(self, firstlex, tagList):
        LexemeCollection.__init__(self, firstlex, tagList)

    # Concatenate words and separate them with a single space.
    def view(self):
        ' '.join(lexemes)
