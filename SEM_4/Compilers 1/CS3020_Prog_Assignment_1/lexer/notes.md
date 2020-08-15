# notes buffer while working on the cool compiler

 - important distinction between the self and SELF_TYPE keywords
	- self will be an attribute of a class
	- SELF_TYPE will be a context based token

 - clarify working of class and object id's and the normal feature identifiers
 - (object oriented dispatch) see into the working of not repeating identifiers within a class for feature names and also not having same class ids
 - precedence order (section 11.1):
 	- also decide on the order of the lexical rules
 - need a mechanism to deal with the escape characters in a string
 - dealing with the fundamental classes and their features
 - the only way to access attributes is through object oriented dispatch. 
	- if in the same class -> can be directly accessed
 - the mandatory existence of Main and a main method inside that
 - Java out of memory error caused when a Token can match the same character stream infinite number of times: a naive reproduction of the same would be matching whitespace as follows 
 ```
  WS	: [ \t]* ->skip; 
 ``` 
	- pretty harmless to look at, but very difficult to zero down on this when debugging
	- careful when you're matching an epsilon
 - read chapter 9 of the TParr book for error handling 
 - treating comments as Tokens : could also be dealt with using a grammar but results in a text error and is fairly simple to do so using lexer
 - issue of greedy matching : putting  a ? after a + or * results in the minimum match
 - using helper token rules for comments : comment 1 and 2 for the 2 kind of comments
 - object id's continuing to include a digit after the first small letter to avoid integers being detected unnecessarily

 - will need modes to deal with contextual tokens : 
 	- * in comments and normal parse mode
	- handling \n differently in string mode : as separately : \\ n

# Interaction between lexer and parser:

[CharStream]===(Lexer)==>[TokenStream]===(Parser)===>[Parse Tree]
 - The listener/visitor routines are called when we traverse around the parse tree
 - we focus on the Lexer section in this assignment
