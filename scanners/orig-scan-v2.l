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
#include "2.7.2.tab.h"

#define YY_USER_ACTION yyextra->col_no += yyleng;

%}

%option yylineno noyywrap noinput nounput 8bit nodefault
%option reentrant
%option extra-type="TokenState*"
%option prefix="py272"

number    {integer}|{longinteger}|{floatnumber}|{imagnumber}

imagnumber     {imaghead}[jJ]
imaghead       {floatnumber}|{intpart}

floatnumber    {pointfloat}|{expfloat}
expfloat       {expfloat_1}{exponent}
expfloat_1     {expfloat_2}|{pointfloat}
expfloat_2     {nonzerodigit}{digit}*
pointfloat     {pointfloat_1}|{pointfloat_2}
pointfloat_1   {intpart}?{fraction}
pointfloat_2   {intpart}\.
intpart        {nzintpart}|0
nzintpart      {nonzerodigit}{digit}*
fraction       \.{digit}+
exponent       [eE][+-]?{digit}+

longinteger    {integer}[lL]
integer        {decinteger}|{octinteger}|{hexinteger}|{bininteger}
decinteger     {nzointeger}|0
nzointeger     {nonzerodigit}{digit}*
hexinteger     0[xX]{hexdigit}+
octinteger     0[oO]{octdigit}+|0{octdigit}+
bininteger     0[bB]{bindigit}+

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

"print_function"            { /* Hack to use 3.x print-style function call */  
                              yyextra->print_name_hack = yyextra->seen_future; 
                              return PY272_NAME; }
"__future__"                { yyextra->seen_future = true; return PY272_NAME; }

{bom_marker}                { check_bom(yylineno, yyextra->col_no); }

{ws}*{comment}?{newline}    { if (explicit_newline(yyextra)) return PY272_NEWLINE; }

"\\"{newline}               {  yyextra->cont_line = true;  mark_new_line(yyextra); /* Explicit line joining: throw it away */ ;  }


{stringprefix}?"'''"        { mark_long_string_start(yyextra, yylineno); BEGIN(LONG_STRING); }
<LONG_STRING>"'''"          { mark_long_string_end(yyextra); BEGIN(INITIAL); return PY272_STRING; }

{stringprefix}?"\"\"\""     { mark_long_string_start(yyextra, yylineno); BEGIN(LONG_STRING2); }
<LONG_STRING2>"\"\"\""      { mark_long_string_end(yyextra); BEGIN(INITIAL); return PY272_STRING; }

<LONG_STRING,LONG_STRING2>{newline}    { mark_new_line(yyextra); }
<LONG_STRING,LONG_STRING2>{escapeseq}  { ; }
<LONG_STRING,LONG_STRING2>.            { ; }
<LONG_STRING,LONG_STRING2><<EOF>>      { display_error("unterminated long string at EOF"); }

{string}   { return PY272_STRING; }


"("        { left_enclose(yyextra);  return PY272_LPAR; }
")"        { right_enclose(yyextra); return PY272_RPAR; }
"["        { left_enclose(yyextra);  return PY272_LSQB;  }
"]"        { right_enclose(yyextra); return PY272_RSQB; }
"{"        { left_enclose(yyextra);  return PY272_LBRACE; }
"}"        { right_enclose(yyextra); return PY272_RBRACE; }

":"        { return PY272_COLON; }
","        { return PY272_COMMA; }
";"        { return PY272_SEMI; }

"+"        { return PY272_PLUS; }
"-"        { return PY272_MINUS; }
"*"        { return PY272_STAR; }
"/"        { return PY272_SLASH; }

"<"        { return PY272_LESS; }
">"        { return PY272_GREATER; }
"="        { return PY272_EQUAL; }

"."        { return PY272_DOT; }
"%"        { return PY272_PERCENT; }
"`"        { return PY272_BACKQUOTE; }

"=="       { return PY272_EQEQUAL; }
"!="       { return PY272_NOTEQUAL; }
"<="       { return PY272_LESSEQUAL; }
">="       { return PY272_GREATEREQUAL; }
"<>"       { return PY272_GRLT; }

"~"        { return PY272_TILDE; }
"^"        { return PY272_CIRCUMFLEX; }
"<<"       { return PY272_LEFTSHIFT; }
">>"       { return PY272_RIGHTSHIFT; }
"**"       { return PY272_DOUBLESTAR; }

"+="       { return PY272_PLUSEQUAL; }
"-="       { return PY272_MINEQUAL; }
"*="       { return PY272_STAREQUAL; }
"/="       { return PY272_SLASHEQUAL; }
"%="       { return PY272_PERCENTEQUAL; }
"&="       { return PY272_AMPEREQUAL; }
"|"        { return PY272_BAR; }
"|="       { return PY272_VBAREQUAL; }
"^="       { return PY272_CIRCUMFLEXEQUAL; }
"<<="      { return PY272_LEFTSHIFTEQUAL; }
">>="      { return PY272_RIGHTSHIFTEQUAL; }
"**="      { return PY272_DOUBLESTAREQUAL; }
"//"       { return PY272_DOUBLESLASH; }
"//="      { return PY272_DOUBLESLASHEQUAL; }

"@"        { return PY272_AT; }

"and"      { return PY272_AND; }
"&"        { return PY272_AMPERSAND; }
"not"      { return PY272_NOT; }
"or"       { return PY272_OR; }
"as"       { return PY272_AS; }
"assert"   { return PY272_ASSERT; }
"break"    { return PY272_BREAK; }
"class"    { return PY272_CLASS; }
"continue" { return PY272_CONTINUE; }
"def"      { return PY272_DEF; }
"del"      { return PY272_DEL; }
"elif"     { return PY272_ELIF; }
"else"     { return PY272_ELSE; }
"except"   { return PY272_EXCEPT; }
"exec"     { return PY272_EXEC; }
"finally"  { return PY272_FINALLY; }
"for"      { return PY272_FOR; }
"from"     { return PY272_FROM; }
"global"   { return PY272_GLOBAL; }
"if"       { return PY272_IF; }
"import"   { return PY272_IMPORT; }
"in"       { return PY272_IN; }
"is"       { return PY272_IS; }
"lambda"   { return PY272_LAMBDA; }
"pass"     { return PY272_PASS; }
"print"    { if (yyextra->print_name_hack) return PY272_NAME; else return PY272_PRINT; }
"raise"    { return PY272_RAISE; }
"return"   { return PY272_RETURN; }
"try"      { return PY272_TRY; }
"while"    { return PY272_WHILE; }
"with"     { return PY272_WITH; }
"yield"    { return PY272_YIELD; }

{number}   { return PY272_NUMBER; }
{name}     { return PY272_NAME; }

<<EOF>>    { handle_eof(yyextra); return PY272_ENDMARKER; }

<*>.       { display_error("unknown character"); }


%%

int py272_next_token(yyscan_t scanner)
{
  TokenState* tok = yyget_extra(scanner);
  if(!tok->assigned_to_yyin)
  {
    yy_scan_buffer(tok->input, tok->input_len, scanner);
    tok->assigned_to_yyin = true;
  }
  int token = NO_TOKEN;
  if(tok->seen_endmarker)
    yyterminate();
  /* First check for any pending indents or dedents */
  if(tok->pendin < 0)
  {
    tok->pendin++;
    token = PY272_DEDENT;
  }
  else if(tok->pendin > 0)
  {
    tok->pendin--;
    token = PY272_INDENT;
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
    if(token == PY272_NEWLINE)
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
  if(token == PY272_ENDMARKER)
    tok->seen_endmarker = true; /* Wrap up the next time around */
  return token;
}
