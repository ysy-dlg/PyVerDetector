/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Davide Pizzolotto
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */
%{
 /*--------------------------------------------------------------.
 |  Written by Davide Pizzolotto, based on the original work of  |
 |  James Power, Chris Malloy, and Brian Malloy                  |
 |  (https://github.com/MalloyPower/python-compliance)           |
 |                                                               |
 |  Rewritten to support pure (reentrant) parsing and multiple   |
 |  multiple python versions in the same executable              |
 `--------------------------------------------------------------*/

#include "scanner.h"
#include "tokens.h"

#define YY_USER_ACTION yyextra->col_no += yyleng;

%}

%option yylineno noyywrap noinput nounput 8bit nodefault
%option reentrant
%option extra-type="TokenState*"
%option prefix="py33"

number         {integer}|{floatnumber}|{imagnumber}

imagnumber     ({floatnumber}|{digitpart})[jJ]


floatnumber    {pointfloat}|{exponentfloat}
pointfloat     {digitpart}?{fraction}|{digitpart}\.
exponentfloat  ({digitpart}|{pointfloat}){exponent}
digitpart      {digit}("_"?{digit})*
fraction       \.{digitpart}
exponent       [eE][+-]?{digitpart}

integer        {decinteger}|{bininteger}|{octinteger}|{hexinteger}
decinteger     {nonzerodigit}("_"?{digit})*|0+("_"?0)*
bininteger     0[bB]("_"?{bindigit})+
octinteger     0[oO]("_"?{octdigit})+
hexinteger     0[xX]("_"?{hexdigit})+

nonzerodigit   [1-9]
digit          [0-9]
bindigit       [01]
octdigit       [0-7]
hexdigit       {digit}|[a-fA-F]

string        {stringprefix}?{stringbody}
stringbody    {shortstring}

stringprefix  {ruprefix}|{rbprefix}
ruprefix      [rRuU][rRuU]?
rbprefix      [rRbB][rRbB]?

shortstring       {shortstring1tck}|{shortstring2tck}
shortstring2tck   \"{shortitem2tck}*\"
shortstring1tck   \'{shortitem1tck}*\'
longstring        {longstring1tck}|{longstring2tck}
longstring2tck    \"\"\"{longitem}*\"\"\"
longstring1tck    \'\'\'{longitem}*\'\'\'

shortitem2tck     {shortchar2tck}|{escapeseq}
shortitem1tck     {shortchar1tck}|{escapeseq}
longitem          {longchar}|{escapeseq}
shortchar2tck     [^\n\r\f\"\\]
shortchar1tck     [^\n\r\f\'\\]
longchar          [^\\]
escapeseq         \\.|\\{newline}

id_start          [_a-zA-Z\x80-\xFF]
id_continue       [_a-zA-Z0-9\x80-\xFF]  
name              {id_start}{id_continue}*

ws        [ \t\f]
spaces    {ws}+
stringQQ  [ru]?\"([^\\\"]|\\.)*\"
stringQ   [ru]?\'([^\\\']|\\.)*\'

newline   [\r]?[\n]|[\r]
comment   #.*

bom_marker  [\xEF][\xBB][\xBF]


/***** Start states for multi-line strings and indentation *****/
%x LONG_STRING
%x LONG_STRING2

%%

{comment}                   { ; }
{spaces}                    { ; }

{bom_marker}                { check_bom(yylineno, yyextra->col_no); }

{ws}*{comment}?{newline}    { if (explicit_newline(yyextra)) return NEWLINE; }

"\\"{newline}               {  yyextra->cont_line = true;  mark_new_line(yyextra); /* Explicit line joining: throw it away */ ;  }


{stringprefix}?"'''"        { mark_long_string_start(yyextra, yylineno); BEGIN(LONG_STRING); }
<LONG_STRING>"'''"          { mark_long_string_end(yyextra); BEGIN(INITIAL); return STRING; }

{stringprefix}?"\"\"\""     { mark_long_string_start(yyextra, yylineno); BEGIN(LONG_STRING2); }
<LONG_STRING2>"\"\"\""      { mark_long_string_end(yyextra); BEGIN(INITIAL); return STRING; }

<LONG_STRING,LONG_STRING2>{newline}    { mark_new_line(yyextra); }
<LONG_STRING,LONG_STRING2>{escapeseq}  { ; }
<LONG_STRING,LONG_STRING2>.            { ; }
<LONG_STRING,LONG_STRING2><<EOF>>      { display_error("unterminated long string at EOF"); }

{string}   { return STRING; }


"("        { left_enclose(yyextra);  return LPAR; }
")"        { right_enclose(yyextra); return RPAR; }
"["        { left_enclose(yyextra);  return LSQB;  }
"]"        { right_enclose(yyextra); return RSQB; }
"{"        { left_enclose(yyextra);  return LBRACE; }
"}"        { right_enclose(yyextra); return RBRACE; }

":"        { return COLON; }
","        { return COMMA; }
";"        { return SEMI; }

"+"        { return PLUS; }
"-"        { return MINUS; }
"*"        { return STAR; }
"/"        { return SLASH; }

"<"        { return LESS; }
">"        { return GREATER; }
"="        { return EQUAL; }

"."        { return DOT; }
"%"        { return PERCENT; }

"=="       { return EQEQUAL; }
"!="       { return NOTEQUAL; }
"<="       { return LESSEQUAL; }
">="       { return GREATEREQUAL; }
"<>"       { return GRLT; }

"~"        { return TILDE; }
"^"        { return CIRCUMFLEX; }
"<<"       { return LEFTSHIFT; }
">>"       { return RIGHTSHIFT; }
"**"       { return DOUBLESTAR; }

"+="       { return PLUSEQUAL; }
"-="       { return MINEQUAL; }
"*="       { return STAREQUAL; }
"/="       { return SLASHEQUAL; }
"%="       { return PERCENTEQUAL; }
"&="       { return AMPEREQUAL; }
"|"        { return BAR; }
"|="       { return VBAREQUAL; }
"^="       { return CIRCUMFLEXEQUAL; }
"<<="      { return LEFTSHIFTEQUAL; }
">>="      { return RIGHTSHIFTEQUAL; }
"**="      { return DOUBLESTAREQUAL; }
"//"       { return DOUBLESLASH; }
"//="      { return DOUBLESLASHEQUAL; }

"@"        { return AT; }
"->"       { return ARROW; }
"..."      { return THREE_DOTS; }

"and"      { return AND; }
"&"        { return AMPERSAND; }
"not"      { return NOT; }
"or"       { return OR; }
"as"       { return AS; }
"assert"   { return ASSERT; }
"break"    { return BREAK; }
"class"    { return CLASS; }
"continue" { return CONTINUE; }
"def"      { return DEF; }
"del"      { return DEL; }
"elif"     { return ELIF; }
"else"     { return ELSE; }
"except"   { return EXCEPT; }
"False"    { return FALSE; }
"finally"  { return FINALLY; }
"for"      { return FOR; }
"from"     { return FROM; }
"global"   { return GLOBAL; }
"if"       { return IF; }
"import"   { return IMPORT; }
"in"       { return IN; }
"is"       { return IS; }
"lambda"   { return LAMBDA; }
"None"     { return NONE; }
"nonlocal" { return NONLOCAL; }
"pass"     { return PASS; }
"raise"    { return RAISE; }
"return"   { return RETURN; }
"True"     { return TRUE; }
"try"      { return TRY; }
"while"    { return WHILE; }
"with"     { return WITH; }
"yield"    { return YIELD; }


{name}     { return NAME; }

{number}   { return NUMBER; }

<<EOF>>    { handle_eof(yyextra); return ENDMARKER; }

<*>.       { display_error("unknown character"); }


%%

int py33_next_token(yyscan_t scanner)
{
  TokenState* tok = yyget_extra(scanner);
  int token = NO_TOKEN;
  if(tok->seen_endmarker)
    yyterminate();
  /* First check for any pending indents or dedents */
  if(tok->pendin < 0)
  {
    tok->pendin++;
    token = DEDENT;
  }
  else if(tok->pendin > 0)
  {
    tok->pendin--;
    token = INDENT;
  }
  /* Next check for a pending token */
  else if(tok->pending_token != NO_TOKEN)
  {
    token = tok->pending_token;
    tok->pending_token = NO_TOKEN;
  }
  /* Finally, call the actual scanner */
  else
  {
    token = yylex(scanner);
    if(token == NEWLINE)
    {
      tok->atbol = true;
    }
    else if(tok->atbol)
    {
      tok->atbol = false;
      note_new_indent(tok);
      tok->pending_token = token;
      token = yylex(scanner);
    }
    /* if we get here then nothing is pending, so just return the token */
  }
  if(token == ENDMARKER)
    tok->seen_endmarker = true; /* Wrap up the next time around */
  return token;
}
