--Name 	: Raj Deepaknath Patil
--Roll no : CS18BTECH11039 
--Programming assignment 0 : toy cool programs

-- Possible errors from section 10.2
class Main inherits IO {
	s:String;
	main():Int{
		{
		s <- "strings can't contain unescaped 
			newline characters";
		out_string("the correct way would be to do \
				this");
		0;
		}
	};
};

--ERRORS 
--	- at line 6,7 : unterminated string constant
--	- occurs due to the token definition of the string in the lexical analyser and not a syntactical error from the grammar
--	- also note that coolc will say "..lex and parse.." errors even if only one of them occurs; it's due to lex in this case.
-- 	- the string in the Test class is deliberately made to terminate with an EOF which is again invalid : similar "unterminated string constant" error displayed

class Test{
	t:String<- " created this class just to have the EOF in a string and not going to terminate this with a \" ... 
