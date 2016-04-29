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
                print lex.get_text(), "is not valid"
                return False

        if not self.lexemes[0].is_valid_beginning():
            print self.lexemes[0].get_text(), "is not a valid beginning"
            return False

        if not self.lexemes[-1].is_valid_end():
            print self.lexemes[-1].get_text(), "is not a valid end"
            return False

        return True

    def lexemes_as_stringlist(self):
        '''
        Return a list of all the lexemes represented as strings.
        '''
        lst = []
        for lex in self.lexemes:
            lst.append(lex.get_text())
        return lst

    def view(self, format):
        """
        Render in various data formats according to the parameter.
        """
        if format.lower() == 'json':
            '''
            Expected to return a Python dictonary that can be readily converted
            to json using json.dumps, but it should NOT be a JSON object.
            '''
            strlist=[]
            for lex in self.lexemes:
                strlist.append(lex.get_text())
            prejson = {'lexemes' : strlist,
                        'complete' : self.complete }
            if len(self.tags) > 0:
                prejson['tags'] = self.tags
            return prejson

        elif format.lower() == 'string':
            '''
            Return as a list of the lexemes rendered as strings with get_text.
            '''
            rlist = []
            for lex in self.lexemes:
                rlist.append(lex.get_text())
            return rlist
            
        else:
            raise ValueError('Must specify a valid format!')

    '''
    Secondary "constructor" methods which can load it more specifically.
    '''
    @abc.abstractmethod # define this as an abstract method
    def import_json(self, jsonobj):
        raise NotImplementedError('Unimplemented abstract method!')
