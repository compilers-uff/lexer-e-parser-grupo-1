package chocopy.pa1;
import java.util.*;
import java_cup.runtime.*;
import java.util.ArrayList;
import java.util.Iterator;

%%

/*** Do not change the flags below unless you know what you are doing. ***/

%unicode
%line
%column

%states SCANLINE, SCANSTRING

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

    /* Indentation Auxiliary Properties */
    private Stack<Integer> indentStack = new Stack<Integer>(); { indentStack.push(0); } // Keeps track of indentation levels
    private Queue<Symbol> indentBuffer = new LinkedList<Symbol>(); // Queue of symbols to be returned before a line is scanned

    /* String Literals Auxiliary Properties */
    private String currentString = ""; // String literal being built
    private int currentStringLine = 0, currentStringColumn = 0; // Line and column of the string literal

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
   
    /* Count the number of whole tabs (4 spaces = 1 tab) in a line. */
    private int countIndent(String line) {
      int count = 0;

      // Iterate through the line and count spaces and tabs
      for (int i = 0; i < line.length(); i++) {
        char ch = line.charAt(i); // Get the character at the current index

        if (ch == ' ') count++; // Adds 1 to the counter
        else if (ch == '\t') count += 4 - (count % 4); // Adds the amount of remaining spaces to next tab (next multiple of 4) to the counter
        else break; // Stop counting at first non-whitespace character
      }

      // Return number of whole tabs.
      return count / 4;
    }
    
%}

/* Macros (regexes used in rules below) */

/* Line Delimeters */
WhiteSpace = [ \t]
NewLine  = \r|\n|\r\n

/* Line Structure */
LogicLine = {WhiteSpace}* [^\r\n]+
Comments = {WhiteSpace}* "#" [^\r\n]*
BlankLine = {WhiteSpace}* {NewLine}

/* Identifiers */
Identifier = [a-zA-Z_][a-zA-Z0-9_]*

/* Keywords */
GlobalKeyword = "global"
NonLocalKeyword = "nonlocal"
LambdaKeyword = "lambda"
AsKeyword = "as"
AssertKeyword = "assert"
AwaitKeyword = "await"
BreakKeyword = "break"
ContinueKeyword = "continue" 
DelKeyword = "del"
ExceptKeyword = "except"
FinallyKeyword = "finally"
FromKeyword = "from"
ImportKeyword = "import"
RaiseKeyword = "raise"
TryKeyword = "try"
WithKeyword = "with"
YieldKeyword = "yield"

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
TrueLiteral = "True"
FalseLiteral = "False"
IntegerLiteral = 0 | [1-9][0-9]*

/* String Literals */
StringDelimiter = "\""
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
DivideOperator = "//" | "/"
ModOperator = "%"
EqualOperator = "=="
NotEqualOperator = "!="
LessThanOrEqualOperator = "<="
GreaterThanOrEqualOperator = ">="
LessThanOperator = "<"
GreaterThanOperator = ">"

/* Delimeters */
Dot = "."
Comma = ","
Colon = ":"
Arrow = "->"
LeftParenthesis = "("
RightParenthesis = ")"
LeftBracket = "["
RightBracket = "]"

%%

<YYINITIAL> {
  /* Line Structure */                             
  {Comments}                  { /* ignore */ }
  {BlankLine}                 { /* ignore */ }
  {LogicLine}                 {
    // Check if the Indentation Buffer is empty. If it is not, return the first symbol in the buffer until it is empty without consuming the line.
    if (!indentBuffer.isEmpty()) {
      yypushback(yylength());
      return indentBuffer.poll();
    }

    int indent = countIndent(yytext()); // Count the number of whole tabs in the line
    int top = indentStack.peek(); // Get the current indentation level

    if (indent == top) { // If the indentation level is the same as the previous line, scan the line
      yypushback(yylength());
      yybegin(SCANLINE);
    } else if (indent > top) { // If the indentation level is greater than the previous line, push a new indentation level and scan the line
      indentStack.push(indent);
      yypushback(yylength());
      yybegin(SCANLINE);
      return symbol(ChocoPyTokens.INDENT);
    } else { // If the indentation level is less than the previous line, pop indentation levels until the current level is reached
      while (indent < top) {
        indentStack.pop();
        indentBuffer.add(symbol(ChocoPyTokens.DEDENT)); // Add a DEDENT symbol to the buffer so that multiple tokens can be returned before the line is scanned
      }
      yypushback(yylength());
    }
  }
}

<SCANLINE> {
  /* Delimiters */
  {NewLine}                    { yybegin(YYINITIAL); return symbol(ChocoPyTokens.NEWLINE); }
  {Comma}                      { return symbol(ChocoPyTokens.COMMA); }
  {Colon}                      { return symbol(ChocoPyTokens.COLON); }

  /* Literals */
  {IntegerLiteral}             { return symbol(ChocoPyTokens.NUMBER, Integer.parseInt(yytext())); }
  {StringDelimiter}            { currentString = ""; currentStringLine = yyline + 1; currentStringColumn = yycolumn + 1; yybegin(SCANSTRING); }
  {TrueLiteral}                { return symbol(ChocoPyTokens.BOOLEAN, true); }
  {FalseLiteral}               { return symbol(ChocoPyTokens.BOOLEAN, false); }
  {NoneLiteral}                { return symbol(ChocoPyTokens.NONE); }

  /* Keywords */
  {GlobalKeyword}              { return symbol(ChocoPyTokens.GLOBAL); }
  {NonLocalKeyword}            { return symbol(ChocoPyTokens.NONLOCAL); }
  {LambdaKeyword}              { return symbol(ChocoPyTokens.LAMBDA); }
  {AsKeyword}                  { return symbol(ChocoPyTokens.AS); }
  {AssertKeyword}              { return symbol(ChocoPyTokens.ASSERT); }
  {AwaitKeyword}               { return symbol(ChocoPyTokens.AWAIT); }
  {BreakKeyword}               { return symbol(ChocoPyTokens.BREAK); }
  {ContinueKeyword}            { return symbol(ChocoPyTokens.CONTINUE); }
  {DelKeyword}                 { return symbol(ChocoPyTokens.DEL); }
  {ExceptKeyword}              { return symbol(ChocoPyTokens.EXCEPT); }
  {FinallyKeyword}             { return symbol(ChocoPyTokens.FINALLY); }
  {FromKeyword}                { return symbol(ChocoPyTokens.FROM); }
  {ImportKeyword}              { return symbol(ChocoPyTokens.IMPORT); }
  {RaiseKeyword}               { return symbol(ChocoPyTokens.RAISE); }
  {TryKeyword}                 { return symbol(ChocoPyTokens.TRY); }
  {WithKeyword}                { return symbol(ChocoPyTokens.WITH); }
  {YieldKeyword}               { return symbol(ChocoPyTokens.YIELD); }

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

  /* Delimeters */
  {Dot}                        { return symbol(ChocoPyTokens.DOT); }
  {Arrow}                      { return symbol(ChocoPyTokens.ARROW); }
  {LeftParenthesis}            { return symbol(ChocoPyTokens.LPAREN); }
  {RightParenthesis}           { return symbol(ChocoPyTokens.RPAREN); }
  {LeftBracket}                { return symbol(ChocoPyTokens.LBRACKET); }
  {RightBracket}               { return symbol(ChocoPyTokens.RBRACKET); }

  /* Identifiers */
  {Identifier}                 { return symbol(ChocoPyTokens.ID, yytext()); }

  /* Delimiters */
  {WhiteSpace}                 { /* ignore */ }

  /* Line Structure */
  {Comments}                   { /* ignore */ }
}

<SCANSTRING> {
  {StringDelimiter}            { 
    yybegin(SCANLINE);          
    return symbolFactory.newSymbol(
      ChocoPyTokens.terminalNames[ChocoPyTokens.STRING],
      ChocoPyTokens.STRING,
      new ComplexSymbolFactory.Location(currentStringLine, currentStringColumn),
      new ComplexSymbolFactory.Location(yyline + 1, yycolumn + yylength()),
      currentString
    );
  }
  {StringChar}                 { currentString += yytext(); }
}

<<EOF>>                        { return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                            { return symbol(ChocoPyTokens.UNRECOGNIZED); }
