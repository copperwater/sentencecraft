'''
Sentence module. Sentence is an instance of Lexeme.
'''

from SentenceCraftApp.Lexeme import Lexeme

class Sentence(Lexeme):
    '''
    Sentence is an instance of the abstract Lexeme.
    '''
    # Abstract function instantiations
    def __init__(self, textString):
        Lexeme.__init__(self, textString)

    def type(self):
        return "sentence"

    def is_valid(self):
        '''
        Valid sentences consist of words separated by spaces.
        For these purposes, a valid word can have at most one non-alphabetic
        character. The first character must be a capital letter.
        The last character must be in a period, question mark, or
        exclamation point.
        '''

        text = self.text
        if not text[0].isupper():
            return False

        if not (text[-1] == '.' or text[-1] == '?' or text[-1] == '!'):
            return False

        words = text.split(' ')
        for word in words:
            if len(word) == 0:
                continue

            non_alpha = 0
            for char in word:
                if not char.isalpha():
                    non_alpha += 1

            if non_alpha > 1:
                return False

        return True

    # There is no special validation for beginning sentences.
    def is_valid_beginning(self):
        return self.is_valid()

    # There is no special validation for ending sentences.
    def is_valid_end(self):
        return self.is_valid()
