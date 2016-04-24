'''
LexemeCollection module. This provides an abstract base class for collections
of different lexemes to inherit from.
'''

# abstract base class module
import abc
import uuid
import json
import Lexeme


class LexemeCollection(object):
    '''
    Abstract represention a collection of lexemes.
    A collection of sentences, words etc.
    '''
    # define metaclass properly as abstract
    __metaclass__ = abc.ABCMeta

    lexemes = [] # list of Lexemes
    tags = [] # list of strings
    complete = False # boolean

    # Constructor
    def __init__(self, lexList=[], complete=False, tagList=[]):
        self.lexemes = lexList
        self.complete = complete
        self.tags = tagList

    def append(self, lex, do_finish=False):
        """
        Add a new lexeme to the list, possibly completing the sentence.
        """
        # TODO type check on lex == Lexeme
        self.lexemes.append(lex)
        if do_finish:
            self.complete = True

    def validate(self):
        """
        Test the lexemes to make sure they are all correctly valid.
        """
        for lex in self.lexemes[1:-1]:
            if not lex.is_valid():
                return False

        return self.lexemes[0].is_valid_beginning() and self.lexemes[-1].is_valid_end()

    '''
    Secondary "constructor" methods which can load it more specifically.
    '''
    @abc.abstractmethod
    def import_json(self, jsonobj):
        raise NotImplementedError('Unimplemented abstract method!')

    @abc.abstractmethod # define this as an abstract method
    def view(self, format):
        """
        Render in various data formats according to the parameter.
        """
        raise NotImplementedError('Unimplemented abstract method!')
