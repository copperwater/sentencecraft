'''
Lexeme module. This provides an abstract base class for various lexemes (like words or sentences) to inherit from.
'''

import abc

class Lexeme(object):
    # define metaclass properly as abstract
    __metaclass__ = abc.ABCMeta

    text=''

    # Constructor
    def __init__(self, textString):
        text=textString

    # Determine if this is a valid instance of its lexeme
    @abc.abstractmethod
    def isValid(self):
        raise NotImplementedError('Unimplemented abstract method!')

    # Determine if this is a valid lexeme to appear at the start of a
    # collection.
    @abc.abstractmethod
    def isValidBeginning(self):
        raise NotImplementedError('Unimplemented abstract method!')

    # Determine if this is a valid lexeme to appear at the end of a collection.
    @abc.abstractmethod
    def isValidEnd(self):
        raise NotImplementedError('Unimplemented abstract method!')

    # Render this lexeme as a string.
    def getText(self):
        return text

    # Also provide a Python-friendly way to render it as a string.
    def __str__(self):
        return getText(self)
