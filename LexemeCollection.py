'''
LexemeCollection module. This provides an abstract base class for collections
of different lexemes to inherit from.
'''

# abstract base class module
import abc
import uuid
import Lexeme


class LexemeCollection(object):
    '''
    Abstract represention a collection of lexemes.
    A collection of sentences, words etc.
    '''
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

    def append(self, lex, do_finish=False):
        """
        Add a new lexeme to the list, possibly completing the sentence.
        """
        # TODO type check on lex == Lexeme
        self.lexemes.append(lex)
        if do_finish:
            self.complete = True

    def check_out(self):
        """
        Mark this lexeme as reserved by generating a random UUID key.
        """
        # TODO: check if it already has a key
        self.key = uuid.uuid4()

    def validate(self):
        """
        Test the lexemes to make sure they are all correctly valid.
        """
        for lex in self.__metaclass__.lexemes[1:-1]:
            if not lex.isValid():
                return False

        return self.lexemes[0].isValidBeginning() and self.lexemes[-1].isValidEnd()

    @abc.abstractmethod # define this as an abstract method
    def view(self):
        """
        Render as a string
        """
        raise NotImplementedError('Unimplemented abstract method!')
