/*
 * The MIT License (MIT)
 * 
 * Copyright (c) 2016 Brian A. Malloy and James F. Power
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
/* This scanner is written by James Power, Chris Malloy, and Brian Malloy
 * During Fall, 2016.  
 * Most of the definitions and specifications were taken from:
 * https://docs.python.org/2.7/reference/index.html
 */

#include "scanner.h"
#include "3.3.tab.h"

/* Code to handle locations */
/* This is taken from Chapter 8 - flex & bison by John Levine */
int yycolumn = 1;

#define YY_USER_ACTION py33lloc.first_line = py33lloc.last_line = py33lineno; \
    py33lloc.first_column = yycolumn; py33lloc.last_column = yycolumn+yyleng-1; \
    yycolumn += yyleng;


/* We want to wrap the generated lexer with our own function */
#define YY_DECL int orig_yylex(void)

static TokenState* tok = NULL;

void assign_variables_py33(FILE* fin, TokenState* t_state);
static void display_error(const char *msg);
static void left_enclose(void);
static void right_enclose(void);
static void mark_long_string_start(void) ;
static void mark_long_string_end(void);
static void mark_new_line(void);
static bool explicit_newline(void);
static void handle_eof(void);

%}

%option yylineno
%option noyywrap
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

{bom_marker}                { if (py33lloc.first_line!=1 && py33lloc.first_column!=1) display_error("unexpected BOM character"); }

{ws}*{comment}?{newline}    { if (explicit_newline()) return NEWLINE; }

"\\"{newline}               {  tok->cont_line = true;  mark_new_line(); /* Explicit line joining: throw it away */ ;  }


{stringprefix}?"'''"        { mark_long_string_start(); BEGIN(LONG_STRING); }
<LONG_STRING>"'''"          { mark_long_string_end(); BEGIN(INITIAL); return STRING; }

{stringprefix}?"\"\"\""     { mark_long_string_start(); BEGIN(LONG_STRING2); }
<LONG_STRING2>"\"\"\""      { mark_long_string_end(); BEGIN(INITIAL); return STRING; }

<LONG_STRING,LONG_STRING2>{newline}    { mark_new_line(); }
<LONG_STRING,LONG_STRING2>{escapeseq}  { ; }
<LONG_STRING,LONG_STRING2>.            { ; }
<LONG_STRING,LONG_STRING2><<EOF>>      { display_error("unterminated long string at EOF"); }

{string}   { return STRING; }


"("        { left_enclose();  return LPAR; }
")"        { right_enclose(); return RPAR; }
"["        { left_enclose();  return LSQB;  }
"]"        { right_enclose(); return RSQB; }
"{"        { left_enclose();  return LBRACE; }
"}"        { right_enclose(); return RBRACE; }

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

<<EOF>>    { handle_eof(); return ENDMARKER; }

<*>.       { display_error("unknown character"); }


%%

void assign_variables_py33(FILE* fin, TokenState* t_state)
{
  yyin = input;
  tok = t_state;
}

static void display_error(const char* msg)
{
  fprintf(stderr, "%d.%d-%d.%d:", py33lloc.first_line, py33lloc.first_column,
          py33lloc.last_line, py33lloc.last_column);
  fprintf(stderr, " lexical error with [%s]: %s\n", py33text, msg);
  exit(EXIT_FAILURE);
}

static void left_enclose(void) { ++tok->level; }

static void right_enclose(void) { --tok->level; }

static void mark_long_string_start(void)
{
  tok->long_string_start_line = py33lloc.first_line;
  tok->long_string_start_col = py33lloc.first_column;
}

static void mark_long_string_end(void)
{
  py33lloc.first_line = tok->long_string_start_line;
  py33lloc.first_column = tok->long_string_start_col;
  tok->long_string_start_line = tok->long_string_start_col = 0;
}

static void mark_new_line(void) { yycolumn = FIRST_COLUMN; }

static bool explicit_newline(void)
{
  bool is_explicit_newline =
      (tok->level == 0) &&
      (tok->cont_line || (py33lloc.first_column > FIRST_COLUMN));
  tok->cont_line = false;
  mark_new_line();
  return is_explicit_newline;
}

static void handle_eof(void)
{
  mark_new_line(); /* Sets current indentation to left margin */
  py33lloc.last_column = py33lloc.first_column = FIRST_COLUMN;
  tok->atbol = true; /* Triggers flushing of the indentation stack */
}

/*** Indentation stack handling  ***/

/* Pop the indentation stack until you get back to col, queue DEDENTs */
static void pop_indents(int col)
{
  if(tok->indent < 0)
  {
    display_error("(internal) indentation stack underflow");
  }
  else
  {
    int curr_indent = tok->indstack[tok->indent];
    if(col < curr_indent)
    {
      tok->pendin--;
      tok->indent--; /* The actual 'pop' */
      pop_indents(col);
    }
    else if(col > curr_indent)
    {
      display_error("dedent is less than corresponding indent");
    }
    /* else col == curr_indent, and we're done */
  }
}

/* Push col onto the indentation stack, queue an INDENT */
static void push_indent(int col)
{
  tok->pendin++;
  tok->indstack[++tok->indent] = col;
}

/* Wrapper that calls push or pop as appropriate */
static void note_new_indent(int col)
{
  int curr_indent = tok->indstack[tok->indent];
  if(col > curr_indent)
    push_indent(col);
  else if(col < curr_indent)
    pop_indents(col);
  /* else col == curr_indent, so do nothing */
}

int yylex(void)
{
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
    token = orig_yylex();
    if(token == NEWLINE)
    {
      tok->atbol = true;
    }
    else if(tok->atbol)
    {
      tok->atbol = false;
      note_new_indent(py33lloc.first_column);
      tok->pending_token = token;
      token = yylex();
    }
    /* if we get here then nothing is pending, so just return the token */
  }
  if(token == ENDMARKER)
    tok->seen_endmarker = true; /* Wrap up the next time around */
  return token;
}
