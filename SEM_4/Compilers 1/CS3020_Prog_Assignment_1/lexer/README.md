# COOL Compiler #

# RAJ PATIL
# CS18BTECH11039	

## Dev phase 0 : LEXER
### Programming Assignment 1
### contains supplementary insights to the comments in the grammar source while developing the Lexer phase of the COOL Compiler. Includes but not limited to:
	- explaining certain decisions
	- supporting correctness arguments
	- reasons to the test cases being 

The basic data flow in ANTLR is as follows :
1. We provide the source code which acts as the character stream
2. The Lexer converts this to a Token stream
3. The Parser converts this Token stream to a Parse Tree
4. We can in turn have actions performed by the host language whenever we visit or are incident on particular internal(grammar rules) or terminal(tokens) nodes in the parse tree while traversing it : we'll be using a visitor in our case as can be seen from the compilation flags in the provided makefiles ( -no-listener -visitor ) ( more on this in the corresponding upcoming assignments )

This Assignment only deals with the Lexer converting the character stream into a token stream

# REFERENCES :
	1. The antlr documentation 
	2. The Definitive ANTLR 4 Reference [by Terrence Parr]

The basic overview of the Lexer:
	- Will have to employ different Lexical modes due to the following reasons:
		- depending on whether we are in a comment or detecting multiplication, a '*' will have different meanings and hence should be treated differently
		- also, once we are in a specific mode, certain characters are treated differently in them (as in actions associated with them); for instance, whitespace should be skipped in normal mode but recorded as it is in a string and is of no increased signigicant relative importance in the comments mode ( for the * version)


## We will need 3 modes due to the above stated reasons:
	1. The "Default" normal mode (untagged)
	2. A string detector mode : S_D
	3. A comment detector mode : C_D

## Now we will need the following extra functionality to handle anomalies in the char stream:
	1. a basic error reporter : which passes an ERROR token into the token stream ( as demanded by the question statement )
	2. a string processor : to check if a string literal is valid ( under give size constraints and doesn't contain a null character ) 
	3. a comment handler 
	4. one for invalid characters

## Pointers for solutions to certain cases:

### COMMENTS
	1. single line comments:
		 - have two fragment rules : with and without newline: matches on with newline if present and is satisfied with an EOF if that's what it needs to do.
	2. to deal with nested comments : using the mode stack to handle them 
		- note that could also use a self referenced token for COMMENTS and have only 1 rule for the nested comments rather than a mode but that doesn't allow for sophisticated error handling (treating different kind of ends differently)
	3. also note that, have to use the hidden channel in this specific case and skip works for all the other use cases when an error is detected because the problem statement asks for the content of the comment to not be tokenized. If skip was used (as in the case of the single line comments), the error ( EOF in comment) is not reported and that is undesired behaviour

### STRINGS
	1. as stated before, we also need a separate mode for strings as there is a difference in the way we treat a character stream in strings and in the general program
	2. the processString function is self-explanatory

### Further notes:
	 - a technicality with antlr is that we can't have rules consuming epsilons :- that results in heap overflow errors due to infinite calls to the visitor function of that terminal :- note that this is said to be a technicality because the language of the grammar is unaffected but building a parse tree becomes infeasible.
		- for instance : use [ \t]+ instead of [ \t]* for whitespace

### test cases: 
	 - 2 files for testing comments (nested and single and with different ends)
	 - 1 for strings (abrupt ends and escape sequences)(with EOF as end)
	 - 1 for strings with a \ at the end of the file
	 - the lexer is also further tested on a single correct complete  program
