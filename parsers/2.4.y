%define api.push-pull push
%define api.pure full
%define api.prefix {py24}

%code top {
  #include <stdio.h>
  #include "2.4.tab.h"
}
%code {
void py24error(const char* msg);
}

// 81 tokens, in alphabetical order:
%token PY24_AMPEREQUAL PY24_AMPERSAND PY24_AND PY24_ASSERT PY24_AT PY24_BACKQUOTE PY24_BAR PY24_BREAK PY24_CIRCUMFLEX
%token PY24_CIRCUMFLEXEQUAL PY24_CLASS PY24_COLON PY24_COMMA PY24_CONTINUE PY24_DEDENT PY24_DEF PY24_DEL PY24_DOT PY24_DOUBLESLASH
%token PY24_DOUBLESLASHEQUAL PY24_DOUBLESTAR PY24_DOUBLESTAREQUAL PY24_ELIF PY24_ELSE PY24_ENDMARKER PY24_EQEQUAL
%token PY24_EQUAL PY24_EXCEPT PY24_EXEC PY24_FINALLY PY24_FOR PY24_FROM PY24_GLOBAL PY24_GREATER PY24_GREATEREQUAL PY24_GRLT
%token PY24_IF PY24_IMPORT PY24_IN PY24_INDENT PY24_IS PY24_LAMBDA PY24_LBRACE PY24_LEFTSHIFT PY24_LEFTSHIFTEQUAL PY24_LESS
%token PY24_LESSEQUAL PY24_LPAR PY24_LSQB PY24_MINEQUAL PY24_MINUS PY24_NAME PY24_NEWLINE PY24_NOT PY24_NOTEQUAL PY24_NUMBER
%token PY24_OR PY24_PASS PY24_PERCENT PY24_PERCENTEQUAL PY24_PLUS PY24_PLUSEQUAL PY24_PRINT PY24_RAISE PY24_RBRACE PY24_RETURN
%token PY24_RIGHTSHIFT PY24_RIGHTSHIFTEQUAL PY24_RPAR PY24_RSQB PY24_SEMI PY24_SLASH PY24_SLASHEQUAL PY24_STAR PY24_STAREQUAL
%token PY24_STRING PY24_TILDE PY24_TRY PY24_VBAREQUAL PY24_WHILE PY24_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY24_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY24_AT dotted_name PY24_LPAR arglist PY24_RPAR PY24_NEWLINE
	| PY24_AT dotted_name PY24_LPAR PY24_RPAR PY24_NEWLINE
	| PY24_AT dotted_name PY24_NEWLINE
	;
decorators // Used in: funcdef
	: plus_decorator
	;
funcdef // Used in: compound_stmt
	: decorators PY24_DEF PY24_NAME parameters PY24_COLON suite
	| PY24_DEF PY24_NAME parameters PY24_COLON suite
	;
parameters // Used in: funcdef
	: PY24_LPAR varargslist PY24_RPAR
	| PY24_LPAR PY24_RPAR
	;
varargslist // Used in: parameters, lambdef
	: star_fpdef_COMMA PY24_STAR PY24_NAME PY24_COMMA PY24_DOUBLESTAR PY24_NAME
	| star_fpdef_COMMA PY24_STAR PY24_NAME
	| star_fpdef_COMMA PY24_DOUBLESTAR PY24_NAME
	| star_fpdef_COMMA fpdef PY24_EQUAL test PY24_COMMA
	| star_fpdef_COMMA fpdef PY24_EQUAL test
	| star_fpdef_COMMA fpdef PY24_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY24_NAME
	| PY24_LPAR fplist PY24_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY24_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY24_SEMI PY24_NEWLINE
	| small_stmt star_SEMI_small_stmt PY24_NEWLINE
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
	: PY24_PLUSEQUAL
	| PY24_MINEQUAL
	| PY24_STAREQUAL
	| PY24_SLASHEQUAL
	| PY24_PERCENTEQUAL
	| PY24_AMPEREQUAL
	| PY24_VBAREQUAL
	| PY24_CIRCUMFLEXEQUAL
	| PY24_LEFTSHIFTEQUAL
	| PY24_RIGHTSHIFTEQUAL
	| PY24_DOUBLESTAREQUAL
	| PY24_DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PY24_PRINT test star_COMMA_test PY24_COMMA
	| PY24_PRINT test star_COMMA_test
	| PY24_PRINT
	| PY24_PRINT PY24_RIGHTSHIFT test plus_COMMA_test PY24_COMMA
	| PY24_PRINT PY24_RIGHTSHIFT test plus_COMMA_test
	| PY24_PRINT PY24_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY24_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY24_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY24_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY24_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY24_RETURN testlist
	| PY24_RETURN
	;
yield_stmt // Used in: flow_stmt
	: PY24_YIELD testlist
	;
raise_stmt // Used in: flow_stmt
	: PY24_RAISE test PY24_COMMA test PY24_COMMA test
	| PY24_RAISE test PY24_COMMA test
	| PY24_RAISE test
	| PY24_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY24_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY24_FROM dotted_name PY24_IMPORT PY24_STAR
	| PY24_FROM dotted_name PY24_IMPORT PY24_LPAR import_as_names PY24_RPAR
	| PY24_FROM dotted_name PY24_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY24_NAME PY24_NAME PY24_NAME
	| PY24_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY24_NAME PY24_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY24_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY24_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY24_GLOBAL PY24_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY24_EXEC expr PY24_IN test PY24_COMMA test
	| PY24_EXEC expr PY24_IN test
	| PY24_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY24_ASSERT test PY24_COMMA test
	| PY24_ASSERT test
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
	: PY24_IF test PY24_COLON suite star_ELIF PY24_ELSE PY24_COLON suite
	| PY24_IF test PY24_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY24_WHILE test PY24_COLON suite PY24_ELSE PY24_COLON suite
	| PY24_WHILE test PY24_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY24_FOR exprlist PY24_IN testlist PY24_COLON suite PY24_ELSE PY24_COLON suite
	| PY24_FOR exprlist PY24_IN testlist PY24_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY24_TRY PY24_COLON suite plus_except PY24_ELSE PY24_COLON suite
	| PY24_TRY PY24_COLON suite plus_except
	| PY24_TRY PY24_COLON suite PY24_FINALLY PY24_COLON suite
	;
except_clause // Used in: plus_except
	: PY24_EXCEPT test PY24_COMMA test
	| PY24_EXCEPT test
	| PY24_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY24_NEWLINE PY24_INDENT plus_stmt PY24_DEDENT
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, except_clause, listmaker, testlist_gexp, lambdef, subscript, sliceop, testlist, testlist_safe, dictmaker, arglist, argument, list_if, gen_for, gen_if, testlist1, star_fpdef_COMMA, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: and_test star_OR_and_test
	| lambdef
	;
and_test // Used in: test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY24_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY24_LESS
	| PY24_GREATER
	| PY24_EQEQUAL
	| PY24_GREATEREQUAL
	| PY24_LESSEQUAL
	| PY24_GRLT
	| PY24_NOTEQUAL
	| PY24_IN
	| PY24_NOT PY24_IN
	| PY24_IS
	| PY24_IS PY24_NOT
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
	: PY24_PLUS factor
	| PY24_MINUS factor
	| PY24_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY24_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY24_LPAR testlist_gexp PY24_RPAR
	| PY24_LPAR PY24_RPAR
	| PY24_LSQB listmaker PY24_RSQB
	| PY24_LSQB PY24_RSQB
	| PY24_LBRACE dictmaker PY24_RBRACE
	| PY24_LBRACE PY24_RBRACE
	| PY24_BACKQUOTE testlist1 PY24_BACKQUOTE
	| PY24_NAME
	| PY24_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY24_COMMA
	| test star_COMMA_test
	;
testlist_gexp // Used in: atom
	: test gen_for
	| test star_COMMA_test PY24_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY24_LAMBDA varargslist PY24_COLON test
	| PY24_LAMBDA PY24_COLON test
	;
trailer // Used in: star_trailer
	: PY24_LPAR arglist PY24_RPAR
	| PY24_LPAR PY24_RPAR
	| PY24_LSQB subscriptlist PY24_RSQB
	| PY24_DOT PY24_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY24_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY24_DOT PY24_DOT PY24_DOT
	| test
	| test PY24_COLON test sliceop
	| test PY24_COLON test
	| test PY24_COLON sliceop
	| test PY24_COLON
	| PY24_COLON test sliceop
	| PY24_COLON test
	| PY24_COLON sliceop
	| PY24_COLON
	;
sliceop // Used in: subscript
	: PY24_COLON test
	| PY24_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for, gen_for
	: expr star_COMMA_expr PY24_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, yield_stmt, for_stmt, classdef, star_EQUAL_testlist
	: test star_COMMA_test PY24_COMMA
	| test star_COMMA_test
	;
testlist_safe // Used in: list_for
	: test plus_COMMA_test PY24_COMMA
	| test plus_COMMA_test
	| test
	;
dictmaker // Used in: atom
	: test PY24_COLON test star_test_COLON_test PY24_COMMA
	| test PY24_COLON test star_test_COLON_test
	;
classdef // Used in: compound_stmt
	: PY24_CLASS PY24_NAME PY24_LPAR testlist PY24_RPAR PY24_COLON suite
	| PY24_CLASS PY24_NAME PY24_COLON suite
	;
arglist // Used in: decorator, trailer
	: star_argument_COMMA argument PY24_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY24_STAR test PY24_COMMA PY24_DOUBLESTAR test
	| star_argument_COMMA PY24_STAR test
	| star_argument_COMMA PY24_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA
	: test PY24_EQUAL test gen_for
	| test PY24_EQUAL test
	| test gen_for
	| test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY24_FOR exprlist PY24_IN testlist_safe list_iter
	| PY24_FOR exprlist PY24_IN testlist_safe
	;
list_if // Used in: list_iter
	: PY24_IF test list_iter
	| PY24_IF test
	;
gen_iter // Used in: gen_for, gen_if
	: gen_for
	| gen_if
	;
gen_for // Used in: testlist_gexp, argument, gen_iter
	: PY24_FOR exprlist PY24_IN test gen_iter
	| PY24_FOR exprlist PY24_IN test
	;
gen_if // Used in: gen_iter
	: PY24_IF test gen_iter
	| PY24_IF test
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY24_EQUAL test PY24_COMMA
	| star_fpdef_COMMA fpdef PY24_COMMA
	| %empty
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY24_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY24_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY24_SEMI small_stmt
	| %empty
	;
star_EQUAL_testlist // Used in: expr_stmt, star_EQUAL_testlist
	: star_EQUAL_testlist PY24_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist_gexp, testlist, testlist1, star_COMMA_test
	: star_COMMA_test PY24_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, testlist_safe, plus_COMMA_test
	: plus_COMMA_test PY24_COMMA test
	| PY24_COMMA test
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY24_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY24_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY24_DOT PY24_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY24_COMMA PY24_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY24_ELIF test PY24_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY24_COLON suite
	| except_clause PY24_COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: test, star_OR_and_test
	: star_OR_and_test PY24_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY24_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY24_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY24_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY24_AMPERSAND shift_expr
	| %empty
	;
star_001 // Used in: shift_expr, star_001
	: star_001 PY24_LEFTSHIFT arith_expr
	| star_001 PY24_RIGHTSHIFT arith_expr
	| %empty
	;
star_002 // Used in: arith_expr, star_002
	: star_002 PY24_PLUS term
	| star_002 PY24_MINUS term
	| %empty
	;
star_003 // Used in: term, star_003
	: star_003 PY24_STAR factor
	| star_003 PY24_SLASH factor
	| star_003 PY24_PERCENT factor
	| star_003 PY24_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY24_STRING
	| PY24_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY24_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY24_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictmaker, star_test_COLON_test
	: star_test_COLON_test PY24_COMMA test PY24_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY24_COMMA
	| %empty
	;

%%

void py24error(const char* msg)
{
}
