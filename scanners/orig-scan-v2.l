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
                              return NAME; }
"__future__"                { yyextra->seen_future = true; return NAME; }

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
"`"        { return BACKQUOTE; }

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
"exec"     { return EXEC; }
"finally"  { return FINALLY; }
"for"      { return FOR; }
"from"     { return FROM; }
"global"   { return GLOBAL; }
"if"       { return IF; }
"import"   { return IMPORT; }
"in"       { return IN; }
"is"       { return IS; }
"lambda"   { return LAMBDA; }
"pass"     { return PASS; }
"print"    { if (yyextra->print_name_hack) return NAME; else return PRINT; }
"raise"    { return RAISE; }
"return"   { return RETURN; }
"try"      { return TRY; }
"while"    { return WHILE; }
"with"     { return WITH; }
"yield"    { return YIELD; }

{number}   { return NUMBER; }
{name}     { return NAME; }

<<EOF>>    { handle_eof(yyextra); return ENDMARKER; }

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
