%define api.push-pull push
%define api.pure full
%define api.prefix {py22}

%code top {
  #include <stdio.h>
  #include "2.2.tab.h"
}
%code {
void py22error(const char* msg);
}

// 80 tokens, in alphabetical order:
%token PY22_AMPEREQUAL PY22_AMPERSAND PY22_AND PY22_ASSERT PY22_BACKQUOTE PY22_BAR PY22_BREAK PY22_CIRCUMFLEX PY22_CIRCUMFLEXEQUAL
%token PY22_CLASS PY22_COLON PY22_COMMA PY22_CONTINUE PY22_DEDENT PY22_DEF PY22_DEL PY22_DOT PY22_DOUBLESLASH PY22_DOUBLESLASHEQUAL
%token PY22_DOUBLESTAR PY22_DOUBLESTAREQUAL PY22_ELIF PY22_ELSE PY22_ENDMARKER PY22_EQEQUAL PY22_EQUAL PY22_EXCEPT
%token PY22_EXEC PY22_FINALLY PY22_FOR PY22_FROM PY22_GLOBAL PY22_GREATER PY22_GREATEREQUAL PY22_GRLT PY22_IF PY22_IMPORT
%token PY22_IN PY22_INDENT PY22_IS PY22_LAMBDA PY22_LBRACE PY22_LEFTSHIFT PY22_LEFTSHIFTEQUAL PY22_LESS PY22_LESSEQUAL
%token PY22_LPAR PY22_LSQB PY22_MINEQUAL PY22_MINUS PY22_NAME PY22_NEWLINE PY22_NOT PY22_NOTEQUAL PY22_NUMBER PY22_OR PY22_PASS
%token PY22_PERCENT PY22_PERCENTEQUAL PY22_PLUS PY22_PLUSEQUAL PY22_PRINT PY22_RAISE PY22_RBRACE PY22_RETURN PY22_RIGHTSHIFT
%token PY22_RIGHTSHIFTEQUAL PY22_RPAR PY22_RSQB PY22_SEMI PY22_SLASH PY22_SLASHEQUAL PY22_STAR PY22_STAREQUAL PY22_STRING
%token PY22_TILDE PY22_TRY PY22_VBAREQUAL PY22_WHILE PY22_YIELD

%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY22_ENDMARKER
	;
funcdef // Used in: compound_stmt
	: PY22_DEF PY22_NAME parameters PY22_COLON suite
	;
parameters // Used in: funcdef
	: PY22_LPAR varargslist PY22_RPAR
	| PY22_LPAR PY22_RPAR
	;
varargslist // Used in: parameters, lambdef
	: star_fpdef_COMMA PY22_STAR PY22_NAME PY22_COMMA PY22_DOUBLESTAR PY22_NAME
	| star_fpdef_COMMA PY22_STAR PY22_NAME
	| star_fpdef_COMMA PY22_DOUBLESTAR PY22_NAME
	| star_fpdef_COMMA fpdef PY22_EQUAL test PY22_COMMA
	| star_fpdef_COMMA fpdef PY22_EQUAL test
	| star_fpdef_COMMA fpdef PY22_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY22_NAME
	| PY22_LPAR fplist PY22_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY22_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY22_SEMI PY22_NEWLINE
	| small_stmt star_SEMI_small_stmt PY22_NEWLINE
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
	: PY22_PLUSEQUAL
	| PY22_MINEQUAL
	| PY22_STAREQUAL
	| PY22_SLASHEQUAL
	| PY22_PERCENTEQUAL
	| PY22_AMPEREQUAL
	| PY22_VBAREQUAL
	| PY22_CIRCUMFLEXEQUAL
	| PY22_LEFTSHIFTEQUAL
	| PY22_RIGHTSHIFTEQUAL
	| PY22_DOUBLESTAREQUAL
	| PY22_DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PY22_PRINT test star_COMMA_test PY22_COMMA
	| PY22_PRINT test star_COMMA_test
	| PY22_PRINT
	| PY22_PRINT PY22_RIGHTSHIFT test plus_COMMA_test PY22_COMMA
	| PY22_PRINT PY22_RIGHTSHIFT test plus_COMMA_test
	| PY22_PRINT PY22_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY22_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY22_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY22_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY22_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY22_RETURN testlist
	| PY22_RETURN
	;
yield_stmt // Used in: flow_stmt
	: PY22_YIELD testlist
	;
raise_stmt // Used in: flow_stmt
	: PY22_RAISE test PY22_COMMA test PY22_COMMA test
	| PY22_RAISE test PY22_COMMA test
	| PY22_RAISE test
	| PY22_RAISE
	;
import_stmt // Used in: small_stmt
	: PY22_IMPORT dotted_as_name star_COMMA_dotted_as_name
	| PY22_FROM dotted_name PY22_IMPORT PY22_STAR
	| PY22_FROM dotted_name PY22_IMPORT import_as_name star_COMMA_import_as_name
	;
import_as_name // Used in: import_stmt, star_COMMA_import_as_name
	: PY22_NAME PY22_NAME PY22_NAME
	| PY22_NAME
	;
dotted_as_name // Used in: import_stmt, star_COMMA_dotted_as_name
	: dotted_name PY22_NAME PY22_NAME
	| dotted_name
	;
dotted_name // Used in: import_stmt, dotted_as_name
	: PY22_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY22_GLOBAL PY22_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY22_EXEC expr PY22_IN test PY22_COMMA test
	| PY22_EXEC expr PY22_IN test
	| PY22_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY22_ASSERT test PY22_COMMA test
	| PY22_ASSERT test
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
	: PY22_IF test PY22_COLON suite star_ELIF PY22_ELSE PY22_COLON suite
	| PY22_IF test PY22_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY22_WHILE test PY22_COLON suite PY22_ELSE PY22_COLON suite
	| PY22_WHILE test PY22_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY22_FOR exprlist PY22_IN testlist PY22_COLON suite PY22_ELSE PY22_COLON suite
	| PY22_FOR exprlist PY22_IN testlist PY22_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY22_TRY PY22_COLON suite plus_except PY22_ELSE PY22_COLON suite
	| PY22_TRY PY22_COLON suite plus_except
	| PY22_TRY PY22_COLON suite PY22_FINALLY PY22_COLON suite
	;
except_clause // Used in: plus_except
	: PY22_EXCEPT test PY22_COMMA test
	| PY22_EXCEPT test
	| PY22_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY22_NEWLINE PY22_INDENT plus_stmt PY22_DEDENT
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, except_clause, listmaker, lambdef, subscript, sliceop, testlist, testlist_safe, dictmaker, arglist, argument, list_if, star_fpdef_COMMA, testlist1, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: and_test star_OR_and_test
	| lambdef
	;
and_test // Used in: test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY22_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY22_LESS
	| PY22_GREATER
	| PY22_EQEQUAL
	| PY22_GREATEREQUAL
	| PY22_LESSEQUAL
	| PY22_GRLT
	| PY22_NOTEQUAL
	| PY22_IN
	| PY22_NOT PY22_IN
	| PY22_IS
	| PY22_IS PY22_NOT
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
	: PY22_PLUS factor
	| PY22_MINUS factor
	| PY22_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY22_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY22_LPAR testlist PY22_RPAR
	| PY22_LPAR PY22_RPAR
	| PY22_LSQB listmaker PY22_RSQB
	| PY22_LSQB PY22_RSQB
	| PY22_LBRACE dictmaker PY22_RBRACE
	| PY22_LBRACE PY22_RBRACE
	| PY22_BACKQUOTE testlist1 PY22_BACKQUOTE
	| PY22_NAME
	| PY22_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY22_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY22_LAMBDA varargslist PY22_COLON test
	| PY22_LAMBDA PY22_COLON test
	;
trailer // Used in: star_trailer
	: PY22_LPAR arglist PY22_RPAR
	| PY22_LPAR PY22_RPAR
	| PY22_LSQB subscriptlist PY22_RSQB
	| PY22_DOT PY22_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY22_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY22_DOT PY22_DOT PY22_DOT
	| test
	| test PY22_COLON test sliceop
	| test PY22_COLON test
	| test PY22_COLON sliceop
	| test PY22_COLON
	| PY22_COLON test sliceop
	| PY22_COLON test
	| PY22_COLON sliceop
	| PY22_COLON
	;
sliceop // Used in: subscript
	: PY22_COLON test
	| PY22_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for
	: expr star_COMMA_expr PY22_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, yield_stmt, for_stmt, atom, classdef, star_EQUAL_testlist
	: test star_COMMA_test PY22_COMMA
	| test star_COMMA_test
	;
testlist_safe // Used in: list_for
	: test plus_COMMA_test PY22_COMMA
	| test plus_COMMA_test
	| test
	;
dictmaker // Used in: atom
	: test PY22_COLON test star_test_COLON_test PY22_COMMA
	| test PY22_COLON test star_test_COLON_test
	;
classdef // Used in: compound_stmt
	: PY22_CLASS PY22_NAME PY22_LPAR testlist PY22_RPAR PY22_COLON suite
	| PY22_CLASS PY22_NAME PY22_COLON suite
	;
arglist // Used in: trailer
	: star_argument_COMMA argument PY22_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY22_STAR test PY22_COMMA PY22_DOUBLESTAR test
	| star_argument_COMMA PY22_STAR test
	| star_argument_COMMA PY22_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA
	: test PY22_EQUAL test
	| test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY22_FOR exprlist PY22_IN testlist_safe list_iter
	| PY22_FOR exprlist PY22_IN testlist_safe
	;
list_if // Used in: list_iter
	: PY22_IF test list_iter
	| PY22_IF test
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY22_EQUAL test PY22_COMMA
	| star_fpdef_COMMA fpdef PY22_COMMA
	| %empty
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY22_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY22_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY22_SEMI small_stmt
	| %empty
	;
star_EQUAL_testlist // Used in: expr_stmt, star_EQUAL_testlist
	: star_EQUAL_testlist PY22_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist, testlist1, star_COMMA_test
	: star_COMMA_test PY22_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, testlist_safe, plus_COMMA_test
	: plus_COMMA_test PY22_COMMA test
	| PY22_COMMA test
	;
star_COMMA_dotted_as_name // Used in: import_stmt, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY22_COMMA dotted_as_name
	| %empty
	;
star_COMMA_import_as_name // Used in: import_stmt, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY22_COMMA import_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY22_DOT PY22_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY22_COMMA PY22_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY22_ELIF test PY22_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY22_COLON suite
	| except_clause PY22_COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: test, star_OR_and_test
	: star_OR_and_test PY22_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY22_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY22_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY22_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY22_AMPERSAND shift_expr
	| %empty
	;
star_001 // Used in: shift_expr, star_001
	: star_001 PY22_LEFTSHIFT arith_expr
	| star_001 PY22_RIGHTSHIFT arith_expr
	| %empty
	;
star_002 // Used in: arith_expr, star_002
	: star_002 PY22_PLUS term
	| star_002 PY22_MINUS term
	| %empty
	;
star_003 // Used in: term, star_003
	: star_003 PY22_STAR factor
	| star_003 PY22_SLASH factor
	| star_003 PY22_PERCENT factor
	| star_003 PY22_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY22_STRING
	| PY22_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY22_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY22_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictmaker, star_test_COLON_test
	: star_test_COLON_test PY22_COMMA test PY22_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY22_COMMA
	| %empty
	;

%%

void py22error(const char* msg)
{
}
