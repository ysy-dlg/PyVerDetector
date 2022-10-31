// Generated by transforming |cwd:///work-in-progress/menhir/conflict-free-ebnf/2.2.mly| on 2018-01-13 at 10:32:04.172+00:00
%{
	int yylex (void);
	extern int yylineno;
	extern char *yytext;
	void yyerror (char const *);
%}

// 80 tokens, in alphabetical order:
%token AMPEREQUAL AMPERSAND AND ASSERT BACKQUOTE BAR BREAK CIRCUMFLEX CIRCUMFLEXEQUAL
%token CLASS COLON COMMA CONTINUE DEDENT DEF DEL DOT DOUBLESLASH DOUBLESLASHEQUAL
%token DOUBLESTAR DOUBLESTAREQUAL ELIF ELSE ENDMARKER EQEQUAL EQUAL EXCEPT
%token EXEC FINALLY FOR FROM GLOBAL GREATER GREATEREQUAL GRLT IF IMPORT
%token IN INDENT IS LAMBDA LBRACE LEFTSHIFT LEFTSHIFTEQUAL LESS LESSEQUAL
%token LPAR LSQB MINEQUAL MINUS NAME NEWLINE NOT NOTEQUAL NUMBER OR PASS
%token PERCENT PERCENTEQUAL PLUS PLUSEQUAL PRINT RAISE RBRACE RETURN RIGHTSHIFT
%token RIGHTSHIFTEQUAL RPAR RSQB SEMI SLASH SLASHEQUAL STAR STAREQUAL STRING
%token TILDE TRY VBAREQUAL WHILE YIELD

%locations


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt ENDMARKER
	;
funcdef // Used in: compound_stmt
	: DEF NAME parameters COLON suite
	;
parameters // Used in: funcdef
	: LPAR varargslist RPAR
	| LPAR RPAR
	;
varargslist // Used in: parameters, lambdef
	: star_fpdef_COMMA STAR NAME COMMA DOUBLESTAR NAME
	| star_fpdef_COMMA STAR NAME
	| star_fpdef_COMMA DOUBLESTAR NAME
	| star_fpdef_COMMA fpdef EQUAL test COMMA
	| star_fpdef_COMMA fpdef EQUAL test
	| star_fpdef_COMMA fpdef COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: NAME
	| LPAR fplist RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt SEMI NEWLINE
	| small_stmt star_SEMI_small_stmt NEWLINE
	;
small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: expr_stmt
	| print_stmt
	| del_stmt
	| pass_stmt
	| flow_stmt
	| import_stmt
	| global_stmt
	| exec_stmt
	| assert_stmt
	;
expr_stmt // Used in: small_stmt
	: testlist augassign testlist
	| testlist star_EQUAL_testlist
	;
augassign // Used in: expr_stmt
	: PLUSEQUAL
	| MINEQUAL
	| STAREQUAL
	| SLASHEQUAL
	| PERCENTEQUAL
	| AMPEREQUAL
	| VBAREQUAL
	| CIRCUMFLEXEQUAL
	| LEFTSHIFTEQUAL
	| RIGHTSHIFTEQUAL
	| DOUBLESTAREQUAL
	| DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PRINT test star_COMMA_test COMMA
	| PRINT test star_COMMA_test
	| PRINT
	| PRINT RIGHTSHIFT test plus_COMMA_test COMMA
	| PRINT RIGHTSHIFT test plus_COMMA_test
	| PRINT RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: BREAK
	;
continue_stmt // Used in: flow_stmt
	: CONTINUE
	;
return_stmt // Used in: flow_stmt
	: RETURN testlist
	| RETURN
	;
yield_stmt // Used in: flow_stmt
	: YIELD testlist
	;
raise_stmt // Used in: flow_stmt
	: RAISE test COMMA test COMMA test
	| RAISE test COMMA test
	| RAISE test
	| RAISE
	;
import_stmt // Used in: small_stmt
	: IMPORT dotted_as_name star_COMMA_dotted_as_name
	| FROM dotted_name IMPORT STAR
	| FROM dotted_name IMPORT import_as_name star_COMMA_import_as_name
	;
import_as_name // Used in: import_stmt, star_COMMA_import_as_name
	: NAME NAME NAME
	| NAME
	;
dotted_as_name // Used in: import_stmt, star_COMMA_dotted_as_name
	: dotted_name NAME NAME
	| dotted_name
	;
dotted_name // Used in: import_stmt, dotted_as_name
	: NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: GLOBAL NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: EXEC expr IN test COMMA test
	| EXEC expr IN test
	| EXEC expr
	;
assert_stmt // Used in: small_stmt
	: ASSERT test COMMA test
	| ASSERT test
	;
compound_stmt // Used in: stmt
	: if_stmt
	| while_stmt
	| for_stmt
	| try_stmt
	| funcdef
	| classdef
	;
if_stmt // Used in: compound_stmt
	: IF test COLON suite star_ELIF ELSE COLON suite
	| IF test COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: WHILE test COLON suite ELSE COLON suite
	| WHILE test COLON suite
	;
for_stmt // Used in: compound_stmt
	: FOR exprlist IN testlist COLON suite ELSE COLON suite
	| FOR exprlist IN testlist COLON suite
	;
try_stmt // Used in: compound_stmt
	: TRY COLON suite plus_except ELSE COLON suite
	| TRY COLON suite plus_except
	| TRY COLON suite FINALLY COLON suite
	;
except_clause // Used in: plus_except
	: EXCEPT test COMMA test
	| EXCEPT test
	| EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| NEWLINE INDENT plus_stmt DEDENT
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, except_clause, listmaker, lambdef, subscript, sliceop, testlist, testlist_safe, dictmaker, arglist, argument, list_if, star_fpdef_COMMA, testlist1, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: and_test star_OR_and_test
	| lambdef
	;
and_test // Used in: test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: LESS
	| GREATER
	| EQEQUAL
	| GREATEREQUAL
	| LESSEQUAL
	| GRLT
	| NOTEQUAL
	| IN
	| NOT IN
	| IS
	| IS NOT
	;
expr // Used in: exec_stmt, comparison, exprlist, star_comp_op_expr, star_COMMA_expr
	: xor_expr star_BAR_xor_expr
	;
xor_expr // Used in: expr, star_BAR_xor_expr
	: and_expr star_CIRCUMFLEX_and_expr
	;
and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: shift_expr star_AMPERSAND_shift_expr
	;
shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: arith_expr star_001
	;
arith_expr // Used in: shift_expr, star_001
	: term star_002
	;
term // Used in: arith_expr, star_002
	: factor star_003
	;
factor // Used in: term, factor, power, star_003
	: PLUS factor
	| MINUS factor
	| TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: LPAR testlist RPAR
	| LPAR RPAR
	| LSQB listmaker RSQB
	| LSQB RSQB
	| LBRACE dictmaker RBRACE
	| LBRACE RBRACE
	| BACKQUOTE testlist1 BACKQUOTE
	| NAME
	| NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: LAMBDA varargslist COLON test
	| LAMBDA COLON test
	;
trailer // Used in: star_trailer
	: LPAR arglist RPAR
	| LPAR RPAR
	| LSQB subscriptlist RSQB
	| DOT NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: DOT DOT DOT
	| test
	| test COLON test sliceop
	| test COLON test
	| test COLON sliceop
	| test COLON
	| COLON test sliceop
	| COLON test
	| COLON sliceop
	| COLON
	;
sliceop // Used in: subscript
	: COLON test
	| COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for
	: expr star_COMMA_expr COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, yield_stmt, for_stmt, atom, classdef, star_EQUAL_testlist
	: test star_COMMA_test COMMA
	| test star_COMMA_test
	;
testlist_safe // Used in: list_for
	: test plus_COMMA_test COMMA
	| test plus_COMMA_test
	| test
	;
dictmaker // Used in: atom
	: test COLON test star_test_COLON_test COMMA
	| test COLON test star_test_COLON_test
	;
classdef // Used in: compound_stmt
	: CLASS NAME LPAR testlist RPAR COLON suite
	| CLASS NAME COLON suite
	;
arglist // Used in: trailer
	: star_argument_COMMA argument COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA STAR test COMMA DOUBLESTAR test
	| star_argument_COMMA STAR test
	| star_argument_COMMA DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA
	: test EQUAL test
	| test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: FOR exprlist IN testlist_safe list_iter
	| FOR exprlist IN testlist_safe
	;
list_if // Used in: list_iter
	: IF test list_iter
	| IF test
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef EQUAL test COMMA
	| star_fpdef_COMMA fpdef COMMA
	| %empty
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt SEMI small_stmt
	| %empty
	;
star_EQUAL_testlist // Used in: expr_stmt, star_EQUAL_testlist
	: star_EQUAL_testlist EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist, testlist1, star_COMMA_test
	: star_COMMA_test COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, testlist_safe, plus_COMMA_test
	: plus_COMMA_test COMMA test
	| COMMA test
	;
star_COMMA_dotted_as_name // Used in: import_stmt, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name COMMA dotted_as_name
	| %empty
	;
star_COMMA_import_as_name // Used in: import_stmt, star_COMMA_import_as_name
	: star_COMMA_import_as_name COMMA import_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME DOT NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME COMMA NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF ELIF test COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause COLON suite
	| except_clause COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: test, star_OR_and_test
	: star_OR_and_test OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr AMPERSAND shift_expr
	| %empty
	;
star_001 // Used in: shift_expr, star_001
	: star_001 LEFTSHIFT arith_expr
	| star_001 RIGHTSHIFT arith_expr
	| %empty
	;
star_002 // Used in: arith_expr, star_002
	: star_002 PLUS term
	| star_002 MINUS term
	| %empty
	;
star_003 // Used in: term, star_003
	: star_003 STAR factor
	| star_003 SLASH factor
	| star_003 PERCENT factor
	| star_003 DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING STRING
	| STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictmaker, star_test_COLON_test
	: star_test_COLON_test COMMA test COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument COMMA
	| %empty
	;

%%

#include <stdio.h>
void yyerror (char const *s)
{
	fprintf (stderr, "%d: %s with [%s]\n", yylineno, s, yytext);
}

