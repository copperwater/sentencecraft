''' 
AbstractCollection module. This provides an abstract base class for collections
of different lexemes to inherit from. 
'''

# abstract base class module
import abc

class AbstractCollection(object):
    # define metaclass properly as abstract
    __metaclass__ = abc.ABCMeta
    
    @abc.abstractmethod # define abstract methods
    def Foo(sthg):
        pass
