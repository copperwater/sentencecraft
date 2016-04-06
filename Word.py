'''
Word module. Word is an instance of Lexeme.
'''

import Lexeme

class Word(Lexeme):

    # Valid words consist of only alphabetic characters.
    # TODO: Valid words can also be all numbers and can end with a , or ;
    def isValid(self):
        return self.text.isAlpha()

    # Valid beginning words are alphabetic and start with a capital letter.
    def isValidBeginning(self):
        return (self.text.isAlpha() and self.text[0].isupper())

    # Valid ending words are alphabetic except for the last letter, which is
    # a . ! or ? character.
    def isValidEnd(self):
        return (self.text[:-1].isAlpha() and (self.text[-1] == '.' or
                                              self.text[-1] == '?' or
                                              self.text[-1] == '!'))
