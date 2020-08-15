lexer grammar CoolLexer;

tokens{
	ERROR,
	TYPEID,
	OBJECTID,
	BOOL_CONST,
	INT_CONST,
	STR_CONST,
	LPAREN,
	RPAREN,
	COLON,
	ATSYM,
	SEMICOLON,
	COMMA,
	PLUS,
	MINUS,
	STAR,
	SLASH,
	TILDE,
	LT,
	EQUALS,
	LBRACE,
	RBRACE,
	DOT,
	DARROW,
	LE,
	ASSIGN,
	CLASS,
	ELSE,
	FI,
	IF,
	IN,
	INHERITS,
	LET,
	LOOP,
	POOL,
	THEN,
	WHILE,
	CASE,
	ESAC,
	OF,
	NEW,
	ISVOID,
	NOT
}
/*
  DO NOT EDIT CODE ABOVE THIS LINE
*/

@members{

	public void reportError(String errorString){
		setText(errorString);
		setType(ERROR);
	}

	public void processString() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();
		String buffer = text.substring(1,text.length()-1);//ignoring the terminal "s
		if(buffer.length()>1024){
			reportError("String constant too long");//returns a ERROR token to the parser
			return;
		}
		if(buffer.indexOf('\0') != -1){//null character present in string before 1024 chars
			reportError("String contains null characters");
			return;
		}
		// now dealing with representation of characters to be escaped in strings
		// considering : \b \n \t \f	
		String e_chars = "ftnb";
		String e_char_map = "\f\t\n\b";
		int idx = buffer.indexOf('\\');
		int e_char_idx;
		while(idx!=-1){
			e_char_idx = e_chars.indexOf(buffer.charAt(idx+1));
			if(e_char_idx != -1){
				// dealing with first case of escaping
				buffer = buffer.substring(0,idx) + e_char_map.charAt(e_char_idx) + buffer.substring(idx+2);//extracting 2 and inserting 1
			}
			else { 
				//dealing with the second demand of escaping in the problem statement
				buffer = buffer.substring(0,idx) + buffer.substring(idx+1);
			}
			idx = buffer.indexOf('\\');
		}
		setText(buffer);
		setType(STR_CONST);
	
	}
	public void invalidChar() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String buffer = t.getText();
		reportError(buffer);
	}

	public void commentHandler() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String buffer = t.getText();
		skip();
	}

}

SEMICOLON   	: ';';
DARROW      	: '=>';
LPAREN 		: '(';
RPAREN		: ')';
COLON		: ':';
ATSYM		: '@';
COMMA		: ',';
PLUS		: '+';
MINUS		: '-';
STAR		: '*';
SLASH		: '/';
TILDE		: '~';
LT		: '<';
EQUALS		: '=';
LBRACE		: '{';
RBRACE		: '}';
DOT		: '.';
LE		: '<=';
ASSIGN		: '<-';

//keywords
CLASS		: C L A S S;
ELSE		: E L S E;
FI		: F I ;
IF		: I F;
IN		: I N ;
INHERITS	: I N H E R I T S;
LET		: L E T;
LOOP		: L O O P;
POOL		: P O O L;
THEN		: T H E N;
WHILE		: W H I L E;
CASE		: C A S E;
ESAC		: E S A C;
OF		: O F;
NEW		: N E W;
ISVOID		: I S V O I D;
NOT		: N O T;

//identifiers
TYPEID		: CLETTER ALPHANUM_USCORE*;
OBJECTID	: SLETTER ALPHANUM_USCORE*;

//literals
INT_CONST	: DIGIT+;
STR_CONST	: '"'~["\n]* '"' {processString();};
BOOL_CONST	: 't' R U E | 'f' A L S E;


COMMENT_SINGLE 	: (COMMENT_SINGLE_NEWLINE|COMMENT_SINGLE_EOF) -> skip;

WS 		: [\n\f\r\v\t\b ]+ -> skip ; //skipping whitespace in normal mode

C_ERROR		: '*' {reportError("Unmatched *)");};//reporting as asked in problem statement


// mode dispatchers
S_BEGIN		: '"' -> skip, pushMode(S_MODE); //detecting start of str start and switching
C_BEGIN		: '(*' -> skip, pushMode(C_MODE);//detecting comment start and switching

mode C_MODE; //comment detector ( only for * version )
C_START		: '(*' -> skip, pushMode(C_MODE);
C_END		: '*)' -> skip, popMode;
EOF_C	: .(EOF) {reportError("EOF in comment");} -> channel(HIDDEN),mode(DEFAULT_MODE);//reason for using a hidden channel rather than skipping discussed in  README.md
C_CONTENT 	: . -> more;

mode S_MODE; //STRING detector
S_END			: '"' {processString();} -> popMode;
NEWLINE			: '\n' {reportError("Unterminated string constant");} -> mode(DEFAULT_MODE) ;
EOF_STR		: .(EOF) {reportError("EOF in string constant");}->  mode(DEFAULT_MODE) ;
STR_CONTENT	: (~('\u0000' | [EOF] | '"' | '\n')('\\''\n')?('\\''\"')?)+ -> more;
//the 'more' command forces the lexer to get another token but without throwing out the current text.


fragment //Helper token rules : not visible to the parser
SLETTER		: [a-z];
CLETTER 	: [A-Z];
LETTER		: SLETTER|CLETTER;
DIGIT		: [0-9];
ALPHANUM_USCORE	: LETTER|DIGIT|'_';

COMMENT_SINGLE_NEWLINE	: '--' ~[\r\n]* '\r'?'\n';
COMMENT_SINGLE_EOF	: '--' ~[\r\n]* ;


//mixed case helpers
A		: [aA];
B		: [bB];
C		: [cC];
D		: [dD];
E		: [eE];
F		: [fF];
G		: [gG];
H		: [hH];
I		: [iI];
J		: [jJ];
K		: [kK];
L		: [lL];
M		: [mM];
N		: [nN];
O		: [oO];
P		: [pP];
Q		: [qQ];
R		: [rR];
S		: [sS];
T		: [tT];
U		: [uU];
V		: [vV];
W		: [wW];
X		: [xX];
Y		: [yY];
Z		: [zZ];
