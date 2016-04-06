'''
Lexeme module. This provides an abstract base class for various lexemes (like words or sentences) to inherit from.
'''

import abc

class Lexeme(object):
    # define metaclass properly as abstract
    __metaclass__ = abc.ABCMeta

    text=''

    def __init__(self, textString):
        text=textString

    @abc.abstractmethod
    def isValid(self):
        raise NotImplementedError('Unimplemented abstract method!')

    @abc.abstractmethod
    def isValidBeginning(self):
        raise NotImplementedError('Unimplemented abstract method!')

    @abc.abstractmethod
    def isValidEnd(self):
        raise NotImplementedError('Unimplemented abstract method!')

    def getText(self):
        return text
