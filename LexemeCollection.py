'''
LexemeCollection module. This provides an abstract base class for collections
of different lexemes to inherit from.
'''

# abstract base class module
import abc
import uuid
import Lexeme

class LexemeCollection(object):
    # define metaclass properly as abstract
    __metaclass__ = abc.ABCMeta

    lexemes = []
    tags = []
    complete = False
    key = ''

    # Constructor
    def __init__(self, firstlex, tagList):
        #TODO: type check on firstlex == string and tagList == list of string
        newlex = Lexeme(firstlex)
        if not newlex.isValid():
            raise ValueError(firstlex + ' is not a valid beginning lexeme')
        self.lexemes = [newlex]
        self.tags = tagList
        self.complete = False
        self.key = ''

    # Add a new lexeme to the list, possibly completing the sentence.
    def append(self, lex, doFinish=False):
        # TODO type check on lex == Lexeme
        self.lexemes.append(lex)
        if doFinish:
            self.complete = True

    # Mark this lexeme as reserved by generating a random UUID key.
    def checkOut(self):
        # TODO: check if it already has a key
        key = uuid.uuid4()

    # Test the lexemes to make sure they are all correctly valid.
    def validate(self):
        for lex in lexemes[1:-1]:
            if not lex.isValid(): return False

        return lexemes[0].isValidBeginning() and
            lexemes[-1].isValidEnd()

    # Render as a string
    @abc.abstractmethod # define this as an abstract method
    def view(self):
        raise NotImplementedError('Unimplemented abstract method!')
