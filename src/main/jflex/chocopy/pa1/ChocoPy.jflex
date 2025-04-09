package chocopy.pa1;
import java_cup.runtime.*;

%%

/*** Do not change the flags below unless you know what you are doing. ***/

%unicode
%line
%column

%class ChocoPyLexer
%public

%cupsym ChocoPyTokens
%cup
%cupdebug

%eofclose false

/*** Do not change the flags above unless you know what you are doing. ***/

/* The following code section is copied verbatim to the
 * generated lexer class. */
%{
    /* The code below includes some convenience methods to create tokens
     * of a given type and optionally a value that the CUP parser can
     * understand. Specifically, a lot of the logic below deals with
     * embedded information about where in the source code a given token
     * was recognized, so that the parser can report errors accurately.
     * (It need not be modified for this project.) */

    /** Producer of token-related values for the parser. */
    final ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();

    /** Return a terminal symbol of syntactic category TYPE and no
     *  semantic value at the current source location. */
    private Symbol symbol(int type) {
        return symbol(type, yytext());
    }

    /** Return a terminal symbol of syntactic category TYPE and semantic
     *  value VALUE at the current source location. */
    private Symbol symbol(int type, Object value) {
        return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[type], type,
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + yylength()),
            value);
    }

%}

/* Macros (regexes used in rules below) */

/* Keywords */
GlobalKeyword = "global"
NonLocalKeyword = "nonlocal"

/* Identifiers */
Identifier = [a-zA-Z_][a-zA-Z0-9_]*
IdentifierString = "\"" {StringChar}* "\""

/* Definitions */
VariableDefinitionOperator = "="
ClassDefinition = "class"
FunctionDefinition = "def"

/* Statements */
IfStatement = "if"
ElifStatement = "elif"
ElseStatement = "else"
WhileStatement = "while"
ForStatement = "for"
PassStatement = "pass"
ReturnStatement = "return"

/* Literals */
NoneLiteral = "None"
BooleanLiteral = "True" | "False"
IntegerLiteral = 0 | [1-9][0-9]*
StringLiteral = "\"" {StringChar}* "\""
StringChar = [^"\\] | "\\" [^"\\]

/* Logic Operators */
InOperator = "in"
NotOperator = "not"
AndOperator = "and"
OrOperator = "or"
IsOperator = "is"

/* Arithmetic Operators */
PlusOperator = "+"
MinusOperator = "-"
MultiplyOperator = "*"
DivideOperator = "//"
ModOperator = "%"
EqualOperator = "=="
NotEqualOperator = "!="
LessThanOrEqualOperator = "<="
GreaterThanOrEqualOperator = ">="
LessThanOperator = "<"
GreaterThanOperator = ">"

/* Punctuation */
Dot = "."
Colon = ":"
Arrow = "->"
LeftParenthesis = "("
RightParenthesis = ")"
LeftBracket = "["
RightBracket = "]"

/* Delimiters */
WhiteSpace = [ \t]
NewLine  = \r|\n|\r\n
Indent    = [ \t]+
/* Dedent    = [ \t]+ */

%%


<YYINITIAL> {
  /* Keywords */
  {GlobalKeyword}              { return symbol(ChocoPyTokens.GLOBAL); }
  {NonLocalKeyword}            { return symbol(ChocoPyTokens.NONLOCAL); }

  /* Identifiers */
  {Identifier}                 { return symbol(ChocoPyTokens.ID, yytext()); }
  {IdentifierString}           { return symbol(ChocoPyTokens.ID_STRING, yytext()); }

  /* Definitions */
  {VariableDefinitionOperator} { return symbol(ChocoPyTokens.EQUAL); }
  {ClassDefinition}            { return symbol(ChocoPyTokens.CLASS); }
  {FunctionDefinition}         { return symbol(ChocoPyTokens.DEF); }

  /* Statements */
  {IfStatement}                { return symbol(ChocoPyTokens.IF); }
  {ElifStatement}              { return symbol(ChocoPyTokens.ELIF); }
  {ElseStatement}              { return symbol(ChocoPyTokens.ELSE); }
  {WhileStatement}             { return symbol(ChocoPyTokens.WHILE); }
  {ForStatement}               { return symbol(ChocoPyTokens.FOR); }
  {PassStatement}              { return symbol(ChocoPyTokens.PASS); }
  {ReturnStatement}            { return symbol(ChocoPyTokens.RETURN); }

  /* Literals */
  {NoneLiteral}                { return symbol(ChocoPyTokens.NONE); }
  {BooleanLiteral}             { return symbol(ChocoPyTokens.BOOLEAN, Boolean.parseBoolean(yytext())); }
  {IntegerLiteral}             { return symbol(ChocoPyTokens.NUMBER, Integer.parseInt(yytext())); }
  {StringLiteral}              { return symbol(ChocoPyTokens.STRING, yytext()); }
  {StringChar}                 { /* ignore */ }

  /* Logic Operators */
  {InOperator}                 { return symbol(ChocoPyTokens.IN); }
  {NotOperator}                { return symbol(ChocoPyTokens.NOT); }
  {AndOperator}                { return symbol(ChocoPyTokens.AND); }
  {OrOperator}                 { return symbol(ChocoPyTokens.OR); }
  {IsOperator}                 { return symbol(ChocoPyTokens.IS); }

  /* Arithmetic Operators */
  {PlusOperator}               { return symbol(ChocoPyTokens.PLUS); }
  {MinusOperator}              { return symbol(ChocoPyTokens.MINUS); }
  {MultiplyOperator}           { return symbol(ChocoPyTokens.MULTIPLY); }
  {DivideOperator}             { return symbol(ChocoPyTokens.DIVIDE); }
  {ModOperator}                { return symbol(ChocoPyTokens.MOD); }
  {EqualOperator}              { return symbol(ChocoPyTokens.EQUALEQUAL); }
  {NotEqualOperator}           { return symbol(ChocoPyTokens.NOTEQUAL); }
  {LessThanOrEqualOperator}    { return symbol(ChocoPyTokens.LTE); }
  {GreaterThanOrEqualOperator} { return symbol(ChocoPyTokens.GTE); }
  {LessThanOperator}           { return symbol(ChocoPyTokens.LT); }
  {GreaterThanOperator}        { return symbol(ChocoPyTokens.GT); }

  /* Punctuation */
  {Dot}                        { return symbol(ChocoPyTokens.DOT); }
  {Colon}                      { return symbol(ChocoPyTokens.COLON); }
  {Arrow}                      { return symbol(ChocoPyTokens.ARROW); }
  {LeftParenthesis}            { return symbol(ChocoPyTokens.LPAREN); }
  {RightParenthesis}           { return symbol(ChocoPyTokens.RPAREN); }
  {LeftBracket}                { return symbol(ChocoPyTokens.LBRACKET); }
  {RightBracket}               { return symbol(ChocoPyTokens.RBRACKET); }

  /* Delimiters. */
  {WhiteSpace}                 { /* ignore */ }
  {NewLine}                    { return symbol(ChocoPyTokens.NEWLINE); }
  {Indent}                     { return symbol(ChocoPyTokens.INDENT); }
  /* {Dedent}                     { return symbol(ChocoPyTokens.DEDENT); } */
}

<<EOF>>                        { return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                            { return symbol(ChocoPyTokens.UNRECOGNIZED); }
