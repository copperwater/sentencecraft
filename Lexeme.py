'''
    Lexeme module. This provides an abstract base
    class for various lexemes (like words or sentences) to inherit from.
'''

import abc

class Lexeme(object):
    """
        Abstract base class for lexemes
    """
    # define metaclass properly as abstract
    __metaclass__ = abc.ABCMeta

    text = ''

    # Constructor
    def __init__(self, textString):
        self.text = textString

    @abc.abstractmethod
    def is_valid(self):
        """
        Determine if this is a valid instance of its lexeme
        """
        raise NotImplementedError('Unimplemented abstract method!')
    @abc.abstractmethod
    def is_valid_beginning(self):
        """
        Determine if this is a valid lexeme to appear at the start of a
        collection.
        """
        raise NotImplementedError('Unimplemented abstract method!')

    @abc.abstractmethod
    def is_valid_end(self):
        """
        Determine if this is a valid lexeme to appear at
        the end of a collection.
        """
        raise NotImplementedError('Unimplemented abstract method!')

    @abc.abstractmethod
    def type(self):
        '''
        Return a string that is the type of this lexeme, like "word".
        '''
        raise NotImplementedError('Unimplemented abstract method!')

    def get_text(self):
        """
        Render this lexeme as a string
        """
        return self.text

    # Also provide a Python-friendly way to render it as a string.
    def __str__(self):
        return self.get_text()
