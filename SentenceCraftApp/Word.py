'''
Word module. Word is an instance of Lexeme.
This is the concrete class in the Template design pattern.
'''

from SentenceCraftApp.Lexeme import Lexeme

class Word(Lexeme):

    '''
    Word is an instance of the abstract Lexeme
    '''
    # Abstract function instantiations
    def __init__(self, textString):
        Lexeme.__init__(self, textString)

    def type(self):
        return "word"

    def is_valid(self):
        '''
        Valid words usually consist of only alphabetic characters.
        Valid words can also be all numbers.
        Valid words can end with a , ; : and can contain a single apostrophe.
        '''
        letters = 0
        numbers = 0
        apostrophes = 0
        punctuations = 0
        for char in self.text:
            if char.isalpha():
                letters += 1
            elif char.isdigit():
                numbers += 1
            elif char == "'":
                apostrophes += 1
            else:
                punctuations += 1
        if punctuations > 1:
            return False # can have max 1 non-apostrophe punctuation
        elif punctuations == 1:
            # needs to be [,;:] at the end
            return self.text[-1] == ',' or self.text[-1] == ';' or self.text[-1] == ':'
        else:
            if apostrophes > 1:
                return False # can have max 1 apostrophe

            if letters == 0 and numbers == len(self.text):
                return True # can be entirely numbers
            if numbers > 0:
                return False # cannot mix numbers and other characters

            # no punctuation, 0-1 apostrophes, no numbers
            return True

    # Valid beginning words are alphabetic and start with a capital letter.
    def is_valid_beginning(self):
        if len(self.text) < 1:
            return False
        return self.is_valid() and self.text[0].isupper()

    # Valid ending words are alphabetic except for the last letter, which is
    # a . ! or ? character.
    def is_valid_end(self):
        if len(self.text) < 1:
            return False
        return (self.text[:-1].isalpha() and (self.text[-1] == '.' or
                                              self.text[-1] == '?' or
                                              self.text[-1] == '!'))
