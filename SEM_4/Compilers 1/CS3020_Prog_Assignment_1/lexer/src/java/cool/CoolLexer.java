// Generated from CoolLexer.g4 by ANTLR 4.5
package cool;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class CoolLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.5", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		ERROR=1, TYPEID=2, OBJECTID=3, BOOL_CONST=4, INT_CONST=5, STR_CONST=6, 
		LPAREN=7, RPAREN=8, COLON=9, ATSYM=10, SEMICOLON=11, COMMA=12, PLUS=13, 
		MINUS=14, STAR=15, SLASH=16, TILDE=17, LT=18, EQUALS=19, LBRACE=20, RBRACE=21, 
		DOT=22, DARROW=23, LE=24, ASSIGN=25, CLASS=26, ELSE=27, FI=28, IF=29, 
		IN=30, INHERITS=31, LET=32, LOOP=33, POOL=34, THEN=35, WHILE=36, CASE=37, 
		ESAC=38, OF=39, NEW=40, ISVOID=41, NOT=42, COMMENT_SINGLE=43, WS=44, C_ERROR=45, 
		S_BEGIN=46, C_BEGIN=47, C_START=48, C_END=49, EOF_C=50, S_END=51, NEWLINE=52, 
		EOF_STR=53, CLETTER=54, LETTER=55, DIGIT=56, ALPHANUM_USCORE=57, COMMENT_SINGLE_NEWLINE=58, 
		COMMENT_SINGLE_EOF=59, A=60, B=61, C=62, D=63, E=64, F=65, G=66, H=67, 
		I=68, J=69, K=70, L=71, M=72, N=73, O=74, P=75, Q=76, R=77, S=78, T=79, 
		U=80, V=81, W=82, X=83, Y=84, Z=85;
	public static final int C_MODE = 1;
	public static final int S_MODE = 2;
	public static String[] modeNames = {
		"DEFAULT_MODE", "C_MODE", "S_MODE"
	};

	public static final String[] ruleNames = {
		"SEMICOLON", "DARROW", "LPAREN", "RPAREN", "COLON", "ATSYM", "COMMA", 
		"PLUS", "MINUS", "STAR", "SLASH", "TILDE", "LT", "EQUALS", "LBRACE", "RBRACE", 
		"DOT", "LE", "ASSIGN", "CLASS", "ELSE", "FI", "IF", "IN", "INHERITS", 
		"LET", "LOOP", "POOL", "THEN", "WHILE", "CASE", "ESAC", "OF", "NEW", "ISVOID", 
		"NOT", "TYPEID", "OBJECTID", "INT_CONST", "STR_CONST", "BOOL_CONST", "COMMENT_SINGLE", 
		"WS", "C_ERROR", "S_BEGIN", "C_BEGIN", "C_START", "C_END", "EOF_C", "C_CONTENT", 
		"S_END", "NEWLINE", "EOF_STR", "STR_CONTENT", "SLETTER", "CLETTER", "LETTER", 
		"DIGIT", "ALPHANUM_USCORE", "COMMENT_SINGLE_NEWLINE", "COMMENT_SINGLE_EOF", 
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", 
		"O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, null, null, null, "'('", "')'", "':'", "'@'", 
		"';'", "','", "'+'", "'-'", null, "'/'", "'~'", "'<'", "'='", "'{'", "'}'", 
		"'.'", "'=>'", "'<='", "'<-'", null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, "'\"'", null, null, "'*)'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "ERROR", "TYPEID", "OBJECTID", "BOOL_CONST", "INT_CONST", "STR_CONST", 
		"LPAREN", "RPAREN", "COLON", "ATSYM", "SEMICOLON", "COMMA", "PLUS", "MINUS", 
		"STAR", "SLASH", "TILDE", "LT", "EQUALS", "LBRACE", "RBRACE", "DOT", "DARROW", 
		"LE", "ASSIGN", "CLASS", "ELSE", "FI", "IF", "IN", "INHERITS", "LET", 
		"LOOP", "POOL", "THEN", "WHILE", "CASE", "ESAC", "OF", "NEW", "ISVOID", 
		"NOT", "COMMENT_SINGLE", "WS", "C_ERROR", "S_BEGIN", "C_BEGIN", "C_START", 
		"C_END", "EOF_C", "S_END", "NEWLINE", "EOF_STR", "CLETTER", "LETTER", 
		"DIGIT", "ALPHANUM_USCORE", "COMMENT_SINGLE_NEWLINE", "COMMENT_SINGLE_EOF", 
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", 
		"O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}



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



	public CoolLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "CoolLexer.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	@Override
	public void action(RuleContext _localctx, int ruleIndex, int actionIndex) {
		switch (ruleIndex) {
		case 39:
			STR_CONST_action((RuleContext)_localctx, actionIndex);
			break;
		case 43:
			C_ERROR_action((RuleContext)_localctx, actionIndex);
			break;
		case 48:
			EOF_C_action((RuleContext)_localctx, actionIndex);
			break;
		case 50:
			S_END_action((RuleContext)_localctx, actionIndex);
			break;
		case 51:
			NEWLINE_action((RuleContext)_localctx, actionIndex);
			break;
		case 52:
			EOF_STR_action((RuleContext)_localctx, actionIndex);
			break;
		}
	}
	private void STR_CONST_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 0:
			processString();
			break;
		}
	}
	private void C_ERROR_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 1:
			reportError("Unmatched *)");
			break;
		}
	}
	private void EOF_C_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 2:
			reportError("EOF in comment");
			break;
		}
	}
	private void S_END_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 3:
			processString();
			break;
		}
	}
	private void NEWLINE_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 4:
			reportError("Unterminated string constant");
			break;
		}
	}
	private void EOF_STR_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 5:
			reportError("EOF in string constant");
			break;
		}
	}

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\2W\u0203\b\1\b\1\b"+
		"\1\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n"+
		"\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21"+
		"\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30"+
		"\4\31\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37"+
		"\4 \t \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t"+
		"*\4+\t+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63"+
		"\4\64\t\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\4<\t"+
		"<\4=\t=\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC\4D\tD\4E\tE\4F\tF\4G\tG\4"+
		"H\tH\4I\tI\4J\tJ\4K\tK\4L\tL\4M\tM\4N\tN\4O\tO\4P\tP\4Q\tQ\4R\tR\4S\t"+
		"S\4T\tT\4U\tU\4V\tV\4W\tW\4X\tX\3\2\3\2\3\3\3\3\3\3\3\4\3\4\3\5\3\5\3"+
		"\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3\r\3\r\3\16"+
		"\3\16\3\17\3\17\3\20\3\20\3\21\3\21\3\22\3\22\3\23\3\23\3\23\3\24\3\24"+
		"\3\24\3\25\3\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\26\3\26\3\27\3\27"+
		"\3\27\3\30\3\30\3\30\3\31\3\31\3\31\3\32\3\32\3\32\3\32\3\32\3\32\3\32"+
		"\3\32\3\32\3\33\3\33\3\33\3\33\3\34\3\34\3\34\3\34\3\34\3\35\3\35\3\35"+
		"\3\35\3\35\3\36\3\36\3\36\3\36\3\36\3\37\3\37\3\37\3\37\3\37\3\37\3 \3"+
		" \3 \3 \3 \3!\3!\3!\3!\3!\3\"\3\"\3\"\3#\3#\3#\3#\3$\3$\3$\3$\3$\3$\3"+
		"$\3%\3%\3%\3%\3&\3&\7&\u0131\n&\f&\16&\u0134\13&\3\'\3\'\7\'\u0138\n\'"+
		"\f\'\16\'\u013b\13\'\3(\6(\u013e\n(\r(\16(\u013f\3)\3)\7)\u0144\n)\f)"+
		"\16)\u0147\13)\3)\3)\3)\3*\3*\3*\3*\3*\3*\3*\3*\3*\3*\3*\5*\u0157\n*\3"+
		"+\3+\5+\u015b\n+\3+\3+\3,\6,\u0160\n,\r,\16,\u0161\3,\3,\3-\3-\3-\3.\3"+
		".\3.\3.\3.\3/\3/\3/\3/\3/\3/\3\60\3\60\3\60\3\60\3\60\3\60\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\63\3\63\3\63\3"+
		"\63\3\64\3\64\3\64\3\64\3\64\3\65\3\65\3\65\3\65\3\65\3\66\3\66\3\66\3"+
		"\66\3\66\3\66\3\67\3\67\3\67\5\67\u019e\n\67\3\67\3\67\5\67\u01a2\n\67"+
		"\6\67\u01a4\n\67\r\67\16\67\u01a5\3\67\3\67\38\38\39\39\3:\3:\5:\u01b0"+
		"\n:\3;\3;\3<\3<\3<\5<\u01b7\n<\3=\3=\3=\3=\7=\u01bd\n=\f=\16=\u01c0\13"+
		"=\3=\5=\u01c3\n=\3=\3=\3>\3>\3>\3>\7>\u01cb\n>\f>\16>\u01ce\13>\3?\3?"+
		"\3@\3@\3A\3A\3B\3B\3C\3C\3D\3D\3E\3E\3F\3F\3G\3G\3H\3H\3I\3I\3J\3J\3K"+
		"\3K\3L\3L\3M\3M\3N\3N\3O\3O\3P\3P\3Q\3Q\3R\3R\3S\3S\3T\3T\3U\3U\3V\3V"+
		"\3W\3W\3X\3X\2\2Y\5\r\7\31\t\t\13\n\r\13\17\f\21\16\23\17\25\20\27\21"+
		"\31\22\33\23\35\24\37\25!\26#\27%\30\'\32)\33+\34-\35/\36\61\37\63 \65"+
		"!\67\"9#;$=%?&A\'C(E)G*I+K,M\4O\5Q\7S\bU\6W-Y.[/]\60_\61a\62c\63e\64g"+
		"\2i\65k\66m\67o\2q\2s8u9w:y;{<}=\177>\u0081?\u0083@\u0085A\u0087B\u0089"+
		"C\u008bD\u008dE\u008fF\u0091G\u0093H\u0095I\u0097J\u0099K\u009bL\u009d"+
		"M\u009fN\u00a1O\u00a3P\u00a5Q\u00a7R\u00a9S\u00abT\u00adU\u00afV\u00b1"+
		"W\5\2\3\4#\4\2\f\f$$\7\2\n\f\16\17\"\"^^xx\7\2\2\2\f\f$$GHQQ\3\2c|\3\2"+
		"C\\\3\2\62;\4\2\f\f\17\17\4\2CCcc\4\2DDdd\4\2EEee\4\2FFff\4\2GGgg\4\2"+
		"HHhh\4\2IIii\4\2JJjj\4\2KKkk\4\2LLll\4\2MMmm\4\2NNnn\4\2OOoo\4\2PPpp\4"+
		"\2QQqq\4\2RRrr\4\2SSss\4\2TTtt\4\2UUuu\4\2VVvv\4\2WWww\4\2XXxx\4\2YYy"+
		"y\4\2ZZzz\4\2[[{{\4\2\\\\||\u020f\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2"+
		"\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25"+
		"\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2"+
		"\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2"+
		"\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3"+
		"\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2"+
		"\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2"+
		"Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3"+
		"\2\2\2\2_\3\2\2\2\3a\3\2\2\2\3c\3\2\2\2\3e\3\2\2\2\3g\3\2\2\2\4i\3\2\2"+
		"\2\4k\3\2\2\2\4m\3\2\2\2\4o\3\2\2\2\4s\3\2\2\2\4u\3\2\2\2\4w\3\2\2\2\4"+
		"y\3\2\2\2\4{\3\2\2\2\4}\3\2\2\2\4\177\3\2\2\2\4\u0081\3\2\2\2\4\u0083"+
		"\3\2\2\2\4\u0085\3\2\2\2\4\u0087\3\2\2\2\4\u0089\3\2\2\2\4\u008b\3\2\2"+
		"\2\4\u008d\3\2\2\2\4\u008f\3\2\2\2\4\u0091\3\2\2\2\4\u0093\3\2\2\2\4\u0095"+
		"\3\2\2\2\4\u0097\3\2\2\2\4\u0099\3\2\2\2\4\u009b\3\2\2\2\4\u009d\3\2\2"+
		"\2\4\u009f\3\2\2\2\4\u00a1\3\2\2\2\4\u00a3\3\2\2\2\4\u00a5\3\2\2\2\4\u00a7"+
		"\3\2\2\2\4\u00a9\3\2\2\2\4\u00ab\3\2\2\2\4\u00ad\3\2\2\2\4\u00af\3\2\2"+
		"\2\4\u00b1\3\2\2\2\5\u00b3\3\2\2\2\7\u00b5\3\2\2\2\t\u00b8\3\2\2\2\13"+
		"\u00ba\3\2\2\2\r\u00bc\3\2\2\2\17\u00be\3\2\2\2\21\u00c0\3\2\2\2\23\u00c2"+
		"\3\2\2\2\25\u00c4\3\2\2\2\27\u00c6\3\2\2\2\31\u00c8\3\2\2\2\33\u00ca\3"+
		"\2\2\2\35\u00cc\3\2\2\2\37\u00ce\3\2\2\2!\u00d0\3\2\2\2#\u00d2\3\2\2\2"+
		"%\u00d4\3\2\2\2\'\u00d6\3\2\2\2)\u00d9\3\2\2\2+\u00dc\3\2\2\2-\u00e2\3"+
		"\2\2\2/\u00e7\3\2\2\2\61\u00ea\3\2\2\2\63\u00ed\3\2\2\2\65\u00f0\3\2\2"+
		"\2\67\u00f9\3\2\2\29\u00fd\3\2\2\2;\u0102\3\2\2\2=\u0107\3\2\2\2?\u010c"+
		"\3\2\2\2A\u0112\3\2\2\2C\u0117\3\2\2\2E\u011c\3\2\2\2G\u011f\3\2\2\2I"+
		"\u0123\3\2\2\2K\u012a\3\2\2\2M\u012e\3\2\2\2O\u0135\3\2\2\2Q\u013d\3\2"+
		"\2\2S\u0141\3\2\2\2U\u0156\3\2\2\2W\u015a\3\2\2\2Y\u015f\3\2\2\2[\u0165"+
		"\3\2\2\2]\u0168\3\2\2\2_\u016d\3\2\2\2a\u0173\3\2\2\2c\u0179\3\2\2\2e"+
		"\u017f\3\2\2\2g\u0186\3\2\2\2i\u018a\3\2\2\2k\u018f\3\2\2\2m\u0194\3\2"+
		"\2\2o\u01a3\3\2\2\2q\u01a9\3\2\2\2s\u01ab\3\2\2\2u\u01af\3\2\2\2w\u01b1"+
		"\3\2\2\2y\u01b6\3\2\2\2{\u01b8\3\2\2\2}\u01c6\3\2\2\2\177\u01cf\3\2\2"+
		"\2\u0081\u01d1\3\2\2\2\u0083\u01d3\3\2\2\2\u0085\u01d5\3\2\2\2\u0087\u01d7"+
		"\3\2\2\2\u0089\u01d9\3\2\2\2\u008b\u01db\3\2\2\2\u008d\u01dd\3\2\2\2\u008f"+
		"\u01df\3\2\2\2\u0091\u01e1\3\2\2\2\u0093\u01e3\3\2\2\2\u0095\u01e5\3\2"+
		"\2\2\u0097\u01e7\3\2\2\2\u0099\u01e9\3\2\2\2\u009b\u01eb\3\2\2\2\u009d"+
		"\u01ed\3\2\2\2\u009f\u01ef\3\2\2\2\u00a1\u01f1\3\2\2\2\u00a3\u01f3\3\2"+
		"\2\2\u00a5\u01f5\3\2\2\2\u00a7\u01f7\3\2\2\2\u00a9\u01f9\3\2\2\2\u00ab"+
		"\u01fb\3\2\2\2\u00ad\u01fd\3\2\2\2\u00af\u01ff\3\2\2\2\u00b1\u0201\3\2"+
		"\2\2\u00b3\u00b4\7=\2\2\u00b4\6\3\2\2\2\u00b5\u00b6\7?\2\2\u00b6\u00b7"+
		"\7@\2\2\u00b7\b\3\2\2\2\u00b8\u00b9\7*\2\2\u00b9\n\3\2\2\2\u00ba\u00bb"+
		"\7+\2\2\u00bb\f\3\2\2\2\u00bc\u00bd\7<\2\2\u00bd\16\3\2\2\2\u00be\u00bf"+
		"\7B\2\2\u00bf\20\3\2\2\2\u00c0\u00c1\7.\2\2\u00c1\22\3\2\2\2\u00c2\u00c3"+
		"\7-\2\2\u00c3\24\3\2\2\2\u00c4\u00c5\7/\2\2\u00c5\26\3\2\2\2\u00c6\u00c7"+
		"\7,\2\2\u00c7\30\3\2\2\2\u00c8\u00c9\7\61\2\2\u00c9\32\3\2\2\2\u00ca\u00cb"+
		"\7\u0080\2\2\u00cb\34\3\2\2\2\u00cc\u00cd\7>\2\2\u00cd\36\3\2\2\2\u00ce"+
		"\u00cf\7?\2\2\u00cf \3\2\2\2\u00d0\u00d1\7}\2\2\u00d1\"\3\2\2\2\u00d2"+
		"\u00d3\7\177\2\2\u00d3$\3\2\2\2\u00d4\u00d5\7\60\2\2\u00d5&\3\2\2\2\u00d6"+
		"\u00d7\7>\2\2\u00d7\u00d8\7?\2\2\u00d8(\3\2\2\2\u00d9\u00da\7>\2\2\u00da"+
		"\u00db\7/\2\2\u00db*\3\2\2\2\u00dc\u00dd\5\u0083A\2\u00dd\u00de\5\u0095"+
		"J\2\u00de\u00df\5\177?\2\u00df\u00e0\5\u00a3Q\2\u00e0\u00e1\5\u00a3Q\2"+
		"\u00e1,\3\2\2\2\u00e2\u00e3\5\u0087C\2\u00e3\u00e4\5\u0095J\2\u00e4\u00e5"+
		"\5\u00a3Q\2\u00e5\u00e6\5\u0087C\2\u00e6.\3\2\2\2\u00e7\u00e8\5\u0089"+
		"D\2\u00e8\u00e9\5\u008fG\2\u00e9\60\3\2\2\2\u00ea\u00eb\5\u008fG\2\u00eb"+
		"\u00ec\5\u0089D\2\u00ec\62\3\2\2\2\u00ed\u00ee\5\u008fG\2\u00ee\u00ef"+
		"\5\u0099L\2\u00ef\64\3\2\2\2\u00f0\u00f1\5\u008fG\2\u00f1\u00f2\5\u0099"+
		"L\2\u00f2\u00f3\5\u008dF\2\u00f3\u00f4\5\u0087C\2\u00f4\u00f5\5\u00a1"+
		"P\2\u00f5\u00f6\5\u008fG\2\u00f6\u00f7\5\u00a5R\2\u00f7\u00f8\5\u00a3"+
		"Q\2\u00f8\66\3\2\2\2\u00f9\u00fa\5\u0095J\2\u00fa\u00fb\5\u0087C\2\u00fb"+
		"\u00fc\5\u00a5R\2\u00fc8\3\2\2\2\u00fd\u00fe\5\u0095J\2\u00fe\u00ff\5"+
		"\u009bM\2\u00ff\u0100\5\u009bM\2\u0100\u0101\5\u009dN\2\u0101:\3\2\2\2"+
		"\u0102\u0103\5\u009dN\2\u0103\u0104\5\u009bM\2\u0104\u0105\5\u009bM\2"+
		"\u0105\u0106\5\u0095J\2\u0106<\3\2\2\2\u0107\u0108\5\u00a5R\2\u0108\u0109"+
		"\5\u008dF\2\u0109\u010a\5\u0087C\2\u010a\u010b\5\u0099L\2\u010b>\3\2\2"+
		"\2\u010c\u010d\5\u00abU\2\u010d\u010e\5\u008dF\2\u010e\u010f\5\u008fG"+
		"\2\u010f\u0110\5\u0095J\2\u0110\u0111\5\u0087C\2\u0111@\3\2\2\2\u0112"+
		"\u0113\5\u0083A\2\u0113\u0114\5\177?\2\u0114\u0115\5\u00a3Q\2\u0115\u0116"+
		"\5\u0087C\2\u0116B\3\2\2\2\u0117\u0118\5\u0087C\2\u0118\u0119\5\u00a3"+
		"Q\2\u0119\u011a\5\177?\2\u011a\u011b\5\u0083A\2\u011bD\3\2\2\2\u011c\u011d"+
		"\5\u009bM\2\u011d\u011e\5\u0089D\2\u011eF\3\2\2\2\u011f\u0120\5\u0099"+
		"L\2\u0120\u0121\5\u0087C\2\u0121\u0122\5\u00abU\2\u0122H\3\2\2\2\u0123"+
		"\u0124\5\u008fG\2\u0124\u0125\5\u00a3Q\2\u0125\u0126\5\u00a9T\2\u0126"+
		"\u0127\5\u009bM\2\u0127\u0128\5\u008fG\2\u0128\u0129\5\u0085B\2\u0129"+
		"J\3\2\2\2\u012a\u012b\5\u0099L\2\u012b\u012c\5\u009bM\2\u012c\u012d\5"+
		"\u00a5R\2\u012dL\3\2\2\2\u012e\u0132\5s9\2\u012f\u0131\5y<\2\u0130\u012f"+
		"\3\2\2\2\u0131\u0134\3\2\2\2\u0132\u0130\3\2\2\2\u0132\u0133\3\2\2\2\u0133"+
		"N\3\2\2\2\u0134\u0132\3\2\2\2\u0135\u0139\5q8\2\u0136\u0138\5y<\2\u0137"+
		"\u0136\3\2\2\2\u0138\u013b\3\2\2\2\u0139\u0137\3\2\2\2\u0139\u013a\3\2"+
		"\2\2\u013aP\3\2\2\2\u013b\u0139\3\2\2\2\u013c\u013e\5w;\2\u013d\u013c"+
		"\3\2\2\2\u013e\u013f\3\2\2\2\u013f\u013d\3\2\2\2\u013f\u0140\3\2\2\2\u0140"+
		"R\3\2\2\2\u0141\u0145\7$\2\2\u0142\u0144\n\2\2\2\u0143\u0142\3\2\2\2\u0144"+
		"\u0147\3\2\2\2\u0145\u0143\3\2\2\2\u0145\u0146\3\2\2\2\u0146\u0148\3\2"+
		"\2\2\u0147\u0145\3\2\2\2\u0148\u0149\7$\2\2\u0149\u014a\b)\2\2\u014aT"+
		"\3\2\2\2\u014b\u014c\7v\2\2\u014c\u014d\5\u00a1P\2\u014d\u014e\5\u00a7"+
		"S\2\u014e\u014f\5\u0087C\2\u014f\u0157\3\2\2\2\u0150\u0151\7h\2\2\u0151"+
		"\u0152\5\177?\2\u0152\u0153\5\u0095J\2\u0153\u0154\5\u00a3Q\2\u0154\u0155"+
		"\5\u0087C\2\u0155\u0157\3\2\2\2\u0156\u014b\3\2\2\2\u0156\u0150\3\2\2"+
		"\2\u0157V\3\2\2\2\u0158\u015b\5{=\2\u0159\u015b\5}>\2\u015a\u0158\3\2"+
		"\2\2\u015a\u0159\3\2\2\2\u015b\u015c\3\2\2\2\u015c\u015d\b+\3\2\u015d"+
		"X\3\2\2\2\u015e\u0160\t\3\2\2\u015f\u015e\3\2\2\2\u0160\u0161\3\2\2\2"+
		"\u0161\u015f\3\2\2\2\u0161\u0162\3\2\2\2\u0162\u0163\3\2\2\2\u0163\u0164"+
		"\b,\3\2\u0164Z\3\2\2\2\u0165\u0166\7,\2\2\u0166\u0167\b-\4\2\u0167\\\3"+
		"\2\2\2\u0168\u0169\7$\2\2\u0169\u016a\3\2\2\2\u016a\u016b\b.\3\2\u016b"+
		"\u016c\b.\5\2\u016c^\3\2\2\2\u016d\u016e\7*\2\2\u016e\u016f\7,\2\2\u016f"+
		"\u0170\3\2\2\2\u0170\u0171\b/\3\2\u0171\u0172\b/\6\2\u0172`\3\2\2\2\u0173"+
		"\u0174\7*\2\2\u0174\u0175\7,\2\2\u0175\u0176\3\2\2\2\u0176\u0177\b\60"+
		"\3\2\u0177\u0178\b\60\6\2\u0178b\3\2\2\2\u0179\u017a\7,\2\2\u017a\u017b"+
		"\7+\2\2\u017b\u017c\3\2\2\2\u017c\u017d\b\61\3\2\u017d\u017e\b\61\7\2"+
		"\u017ed\3\2\2\2\u017f\u0180\13\2\2\2\u0180\u0181\7\2\2\3\u0181\u0182\b"+
		"\62\b\2\u0182\u0183\3\2\2\2\u0183\u0184\b\62\t\2\u0184\u0185\b\62\n\2"+
		"\u0185f\3\2\2\2\u0186\u0187\13\2\2\2\u0187\u0188\3\2\2\2\u0188\u0189\b"+
		"\63\13\2\u0189h\3\2\2\2\u018a\u018b\7$\2\2\u018b\u018c\b\64\f\2\u018c"+
		"\u018d\3\2\2\2\u018d\u018e\b\64\7\2\u018ej\3\2\2\2\u018f\u0190\7\f\2\2"+
		"\u0190\u0191\b\65\r\2\u0191\u0192\3\2\2\2\u0192\u0193\b\65\n\2\u0193l"+
		"\3\2\2\2\u0194\u0195\13\2\2\2\u0195\u0196\7\2\2\3\u0196\u0197\b\66\16"+
		"\2\u0197\u0198\3\2\2\2\u0198\u0199\b\66\n\2\u0199n\3\2\2\2\u019a\u019d"+
		"\n\4\2\2\u019b\u019c\7^\2\2\u019c\u019e\7\f\2\2\u019d\u019b\3\2\2\2\u019d"+
		"\u019e\3\2\2\2\u019e\u01a1\3\2\2\2\u019f\u01a0\7^\2\2\u01a0\u01a2\7$\2"+
		"\2\u01a1\u019f\3\2\2\2\u01a1\u01a2\3\2\2\2\u01a2\u01a4\3\2\2\2\u01a3\u019a"+
		"\3\2\2\2\u01a4\u01a5\3\2\2\2\u01a5\u01a3\3\2\2\2\u01a5\u01a6\3\2\2\2\u01a6"+
		"\u01a7\3\2\2\2\u01a7\u01a8\b\67\13\2\u01a8p\3\2\2\2\u01a9\u01aa\t\5\2"+
		"\2\u01aar\3\2\2\2\u01ab\u01ac\t\6\2\2\u01act\3\2\2\2\u01ad\u01b0\5q8\2"+
		"\u01ae\u01b0\5s9\2\u01af\u01ad\3\2\2\2\u01af\u01ae\3\2\2\2\u01b0v\3\2"+
		"\2\2\u01b1\u01b2\t\7\2\2\u01b2x\3\2\2\2\u01b3\u01b7\5u:\2\u01b4\u01b7"+
		"\5w;\2\u01b5\u01b7\7a\2\2\u01b6\u01b3\3\2\2\2\u01b6\u01b4\3\2\2\2\u01b6"+
		"\u01b5\3\2\2\2\u01b7z\3\2\2\2\u01b8\u01b9\7/\2\2\u01b9\u01ba\7/\2\2\u01ba"+
		"\u01be\3\2\2\2\u01bb\u01bd\n\b\2\2\u01bc\u01bb\3\2\2\2\u01bd\u01c0\3\2"+
		"\2\2\u01be\u01bc\3\2\2\2\u01be\u01bf\3\2\2\2\u01bf\u01c2\3\2\2\2\u01c0"+
		"\u01be\3\2\2\2\u01c1\u01c3\7\17\2\2\u01c2\u01c1\3\2\2\2\u01c2\u01c3\3"+
		"\2\2\2\u01c3\u01c4\3\2\2\2\u01c4\u01c5\7\f\2\2\u01c5|\3\2\2\2\u01c6\u01c7"+
		"\7/\2\2\u01c7\u01c8\7/\2\2\u01c8\u01cc\3\2\2\2\u01c9\u01cb\n\b\2\2\u01ca"+
		"\u01c9\3\2\2\2\u01cb\u01ce\3\2\2\2\u01cc\u01ca\3\2\2\2\u01cc\u01cd\3\2"+
		"\2\2\u01cd~\3\2\2\2\u01ce\u01cc\3\2\2\2\u01cf\u01d0\t\t\2\2\u01d0\u0080"+
		"\3\2\2\2\u01d1\u01d2\t\n\2\2\u01d2\u0082\3\2\2\2\u01d3\u01d4\t\13\2\2"+
		"\u01d4\u0084\3\2\2\2\u01d5\u01d6\t\f\2\2\u01d6\u0086\3\2\2\2\u01d7\u01d8"+
		"\t\r\2\2\u01d8\u0088\3\2\2\2\u01d9\u01da\t\16\2\2\u01da\u008a\3\2\2\2"+
		"\u01db\u01dc\t\17\2\2\u01dc\u008c\3\2\2\2\u01dd\u01de\t\20\2\2\u01de\u008e"+
		"\3\2\2\2\u01df\u01e0\t\21\2\2\u01e0\u0090\3\2\2\2\u01e1\u01e2\t\22\2\2"+
		"\u01e2\u0092\3\2\2\2\u01e3\u01e4\t\23\2\2\u01e4\u0094\3\2\2\2\u01e5\u01e6"+
		"\t\24\2\2\u01e6\u0096\3\2\2\2\u01e7\u01e8\t\25\2\2\u01e8\u0098\3\2\2\2"+
		"\u01e9\u01ea\t\26\2\2\u01ea\u009a\3\2\2\2\u01eb\u01ec\t\27\2\2\u01ec\u009c"+
		"\3\2\2\2\u01ed\u01ee\t\30\2\2\u01ee\u009e\3\2\2\2\u01ef\u01f0\t\31\2\2"+
		"\u01f0\u00a0\3\2\2\2\u01f1\u01f2\t\32\2\2\u01f2\u00a2\3\2\2\2\u01f3\u01f4"+
		"\t\33\2\2\u01f4\u00a4\3\2\2\2\u01f5\u01f6\t\34\2\2\u01f6\u00a6\3\2\2\2"+
		"\u01f7\u01f8\t\35\2\2\u01f8\u00a8\3\2\2\2\u01f9\u01fa\t\36\2\2\u01fa\u00aa"+
		"\3\2\2\2\u01fb\u01fc\t\37\2\2\u01fc\u00ac\3\2\2\2\u01fd\u01fe\t \2\2\u01fe"+
		"\u00ae\3\2\2\2\u01ff\u0200\t!\2\2\u0200\u00b0\3\2\2\2\u0201\u0202\t\""+
		"\2\2\u0202\u00b2\3\2\2\2\24\2\3\4\u0132\u0139\u013f\u0145\u0156\u015a"+
		"\u0161\u019d\u01a1\u01a5\u01af\u01b6\u01be\u01c2\u01cc\17\3)\2\b\2\2\3"+
		"-\3\7\4\2\7\3\2\6\2\2\3\62\4\2\3\2\4\2\2\5\2\2\3\64\5\3\65\6\3\66\7";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}