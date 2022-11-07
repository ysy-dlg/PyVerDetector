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
#include "3.3.tab.h"

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
hexdigit       [0-9a-fA-F]

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

{bom_marker}                { check_bom(yyextra, yylineno); yyterminate();}

{ws}*{comment}?{newline}    { if (explicit_newline(yyextra)) return PY33_NEWLINE; }

"\\"{newline}               {  yyextra->cont_line = true;  mark_new_line(yyextra); /* Explicit line joining: throw it away */ ;  }


{stringprefix}?"'''"        { mark_long_string_start(yyextra, yylineno); BEGIN(LONG_STRING); }
<LONG_STRING>"'''"          { mark_long_string_end(yyextra); BEGIN(INITIAL); return PY33_STRING; }

{stringprefix}?"\"\"\""     { mark_long_string_start(yyextra, yylineno); BEGIN(LONG_STRING2); }
<LONG_STRING2>"\"\"\""      { mark_long_string_end(yyextra); BEGIN(INITIAL); return PY33_STRING; }

<LONG_STRING,LONG_STRING2>{newline}    { mark_new_line(yyextra); }
<LONG_STRING,LONG_STRING2>{escapeseq}  { ; }
<LONG_STRING,LONG_STRING2>.            { ; }
<LONG_STRING,LONG_STRING2><<EOF>>      { char msgbuffer[128]; snprintf(msgbuffer, sizeof(msgbuffer), "unterminated long string started at %d", yyextra->long_string_start_line); set_error(yyextra, msgbuffer); yyterminate(); }


{string}   { return PY33_STRING; }


"("        { left_enclose(yyextra);  return PY33_LPAR; }
")"        { right_enclose(yyextra); return PY33_RPAR; }
"["        { left_enclose(yyextra);  return PY33_LSQB;  }
"]"        { right_enclose(yyextra); return PY33_RSQB; }
"{"        { left_enclose(yyextra);  return PY33_LBRACE; }
"}"        { right_enclose(yyextra); return PY33_RBRACE; }

":"        { return PY33_COLON; }
","        { return PY33_COMMA; }
";"        { return PY33_SEMI; }

"+"        { return PY33_PLUS; }
"-"        { return PY33_MINUS; }
"*"        { return PY33_STAR; }
"/"        { return PY33_SLASH; }

"<"        { return PY33_LESS; }
">"        { return PY33_GREATER; }
"="        { return PY33_EQUAL; }

"."        { return PY33_DOT; }
"%"        { return PY33_PERCENT; }

"=="       { return PY33_EQEQUAL; }
"!="       { return PY33_NOTEQUAL; }
"<="       { return PY33_LESSEQUAL; }
">="       { return PY33_GREATEREQUAL; }
"<>"       { return PY33_GRLT; }

"~"        { return PY33_TILDE; }
"^"        { return PY33_CIRCUMFLEX; }
"<<"       { return PY33_LEFTSHIFT; }
">>"       { return PY33_RIGHTSHIFT; }
"**"       { return PY33_DOUBLESTAR; }

"+="       { return PY33_PLUSEQUAL; }
"-="       { return PY33_MINEQUAL; }
"*="       { return PY33_STAREQUAL; }
"/="       { return PY33_SLASHEQUAL; }
"%="       { return PY33_PERCENTEQUAL; }
"&="       { return PY33_AMPEREQUAL; }
"|"        { return PY33_BAR; }
"|="       { return PY33_VBAREQUAL; }
"^="       { return PY33_CIRCUMFLEXEQUAL; }
"<<="      { return PY33_LEFTSHIFTEQUAL; }
">>="      { return PY33_RIGHTSHIFTEQUAL; }
"**="      { return PY33_DOUBLESTAREQUAL; }
"//"       { return PY33_DOUBLESLASH; }
"//="      { return PY33_DOUBLESLASHEQUAL; }

"@"        { return PY33_AT; }
"->"       { return PY33_ARROW; }
"..."      { return PY33_THREE_DOTS; }

"and"      { return PY33_AND; }
"&"        { return PY33_AMPERSAND; }
"not"      { return PY33_NOT; }
"or"       { return PY33_OR; }
"as"       { return PY33_AS; }
"assert"   { return PY33_ASSERT; }
"break"    { return PY33_BREAK; }
"class"    { return PY33_CLASS; }
"continue" { return PY33_CONTINUE; }
"def"      { return PY33_DEF; }
"del"      { return PY33_DEL; }
"elif"     { return PY33_ELIF; }
"else"     { return PY33_ELSE; }
"except"   { return PY33_EXCEPT; }
"False"    { return PY33_FALSE; }
"finally"  { return PY33_FINALLY; }
"for"      { return PY33_FOR; }
"from"     { return PY33_FROM; }
"global"   { return PY33_GLOBAL; }
"if"       { return PY33_IF; }
"import"   { return PY33_IMPORT; }
"in"       { return PY33_IN; }
"is"       { return PY33_IS; }
"lambda"   { return PY33_LAMBDA; }
"None"     { return PY33_NONE; }
"nonlocal" { return PY33_NONLOCAL; }
"pass"     { return PY33_PASS; }
"raise"    { return PY33_RAISE; }
"return"   { return PY33_RETURN; }
"True"     { return PY33_TRUE; }
"try"      { return PY33_TRY; }
"while"    { return PY33_WHILE; }
"with"     { return PY33_WITH; }
"yield"    { return PY33_YIELD; }

{number}   { return PY33_NUMBER; }
{name}     { return PY33_NAME; }

<<EOF>>    { handle_eof(yyextra); return PY33_ENDMARKER; }

<*>.       { char msgbuffer[128]; snprintf(msgbuffer, sizeof(msgbuffer), "unexpected character %s", yytext); set_error(yyextra, msgbuffer); yyterminate();}



%%

int py33_next_token(yyscan_t scanner)
{
  TokenState* tok = yyget_extra(scanner);
  /* First run, initialize buffer */
  if(!tok->assigned_to_yyin)
  {
    yy_scan_buffer(tok->input, tok->input_len, scanner);
    yyset_lineno(1, scanner); // yylineno not initialised in reentrant parsers https://github.com/westes/flex/issues/60
    tok->assigned_to_yyin = true;
  }
  int token = NO_TOKEN;
  if(tok->seen_endmarker)
    yyterminate();
  /* First check for any pending indents or dedents */
  if(tok->pendin < 0)
  {
    tok->pendin++;
    token = PY33_DEDENT;
  }
  else if(tok->pendin > 0)
  {
    tok->pendin--;
    token = PY33_INDENT;
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
    if(token == PY33_NEWLINE)
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
  if(token == PY33_ENDMARKER)
    tok->seen_endmarker = true; /* Wrap up the next time around */
  return token;
}
