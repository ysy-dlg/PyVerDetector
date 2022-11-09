%define api.push-pull push
%define api.pure full
%define api.prefix {py243}
%define parse.error verbose
%parse-param{TokenState* t_state}

%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "2.4.3.tab.h"
}
%code {
void py243error(TokenState* t_state, const char* msg);
}

// 81 tokens, in alphabetical order:
%token PY243_AMPEREQUAL PY243_AMPERSAND PY243_AND PY243_ASSERT PY243_AT PY243_BACKQUOTE PY243_BAR PY243_BREAK PY243_CIRCUMFLEX
%token PY243_CIRCUMFLEXEQUAL PY243_CLASS PY243_COLON PY243_COMMA PY243_CONTINUE PY243_DEDENT PY243_DEF PY243_DEL PY243_DOT PY243_DOUBLESLASH
%token PY243_DOUBLESLASHEQUAL PY243_DOUBLESTAR PY243_DOUBLESTAREQUAL PY243_ELIF PY243_ELSE PY243_ENDMARKER PY243_EQEQUAL
%token PY243_EQUAL PY243_EXCEPT PY243_EXEC PY243_FINALLY PY243_FOR PY243_FROM PY243_GLOBAL PY243_GREATER PY243_GREATEREQUAL PY243_GRLT
%token PY243_IF PY243_IMPORT PY243_IN PY243_INDENT PY243_IS PY243_LAMBDA PY243_LBRACE PY243_LEFTSHIFT PY243_LEFTSHIFTEQUAL PY243_LESS
%token PY243_LESSEQUAL PY243_LPAR PY243_LSQB PY243_MINEQUAL PY243_MINUS PY243_NAME PY243_NEWLINE PY243_NOT PY243_NOTEQUAL PY243_NUMBER
%token PY243_OR PY243_PASS PY243_PERCENT PY243_PERCENTEQUAL PY243_PLUS PY243_PLUSEQUAL PY243_PRINT PY243_RAISE PY243_RBRACE PY243_RETURN
%token PY243_RIGHTSHIFT PY243_RIGHTSHIFTEQUAL PY243_RPAR PY243_RSQB PY243_SEMI PY243_SLASH PY243_SLASHEQUAL PY243_STAR PY243_STAREQUAL
%token PY243_STRING PY243_TILDE PY243_TRY PY243_VBAREQUAL PY243_WHILE PY243_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY243_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY243_AT dotted_name PY243_LPAR arglist PY243_RPAR PY243_NEWLINE
	| PY243_AT dotted_name PY243_LPAR PY243_RPAR PY243_NEWLINE
	| PY243_AT dotted_name PY243_NEWLINE
	;
decorators // Used in: funcdef
	: plus_decorator
	;
funcdef // Used in: compound_stmt
	: decorators PY243_DEF PY243_NAME parameters PY243_COLON suite
	| PY243_DEF PY243_NAME parameters PY243_COLON suite
	;
parameters // Used in: funcdef
	: PY243_LPAR varargslist PY243_RPAR
	| PY243_LPAR PY243_RPAR
	;
varargslist // Used in: parameters, lambdef
	: star_fpdef_COMMA PY243_STAR PY243_NAME PY243_COMMA PY243_DOUBLESTAR PY243_NAME
	| star_fpdef_COMMA PY243_STAR PY243_NAME
	| star_fpdef_COMMA PY243_DOUBLESTAR PY243_NAME
	| star_fpdef_COMMA fpdef PY243_EQUAL test PY243_COMMA
	| star_fpdef_COMMA fpdef PY243_EQUAL test
	| star_fpdef_COMMA fpdef PY243_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY243_NAME
	| PY243_LPAR fplist PY243_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY243_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY243_SEMI PY243_NEWLINE
	| small_stmt star_SEMI_small_stmt PY243_NEWLINE
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
	: PY243_PLUSEQUAL
	| PY243_MINEQUAL
	| PY243_STAREQUAL
	| PY243_SLASHEQUAL
	| PY243_PERCENTEQUAL
	| PY243_AMPEREQUAL
	| PY243_VBAREQUAL
	| PY243_CIRCUMFLEXEQUAL
	| PY243_LEFTSHIFTEQUAL
	| PY243_RIGHTSHIFTEQUAL
	| PY243_DOUBLESTAREQUAL
	| PY243_DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PY243_PRINT test star_COMMA_test PY243_COMMA
	| PY243_PRINT test star_COMMA_test
	| PY243_PRINT
	| PY243_PRINT PY243_RIGHTSHIFT test plus_COMMA_test PY243_COMMA
	| PY243_PRINT PY243_RIGHTSHIFT test plus_COMMA_test
	| PY243_PRINT PY243_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY243_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY243_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY243_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY243_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY243_RETURN testlist
	| PY243_RETURN
	;
yield_stmt // Used in: flow_stmt
	: PY243_YIELD testlist
	;
raise_stmt // Used in: flow_stmt
	: PY243_RAISE test PY243_COMMA test PY243_COMMA test
	| PY243_RAISE test PY243_COMMA test
	| PY243_RAISE test
	| PY243_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY243_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY243_FROM dotted_name PY243_IMPORT PY243_STAR
	| PY243_FROM dotted_name PY243_IMPORT PY243_LPAR import_as_names PY243_RPAR
	| PY243_FROM dotted_name PY243_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY243_NAME PY243_NAME PY243_NAME
	| PY243_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY243_NAME PY243_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY243_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY243_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY243_GLOBAL PY243_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY243_EXEC expr PY243_IN test PY243_COMMA test
	| PY243_EXEC expr PY243_IN test
	| PY243_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY243_ASSERT test PY243_COMMA test
	| PY243_ASSERT test
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
	: PY243_IF test PY243_COLON suite star_ELIF PY243_ELSE PY243_COLON suite
	| PY243_IF test PY243_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY243_WHILE test PY243_COLON suite PY243_ELSE PY243_COLON suite
	| PY243_WHILE test PY243_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY243_FOR exprlist PY243_IN testlist PY243_COLON suite PY243_ELSE PY243_COLON suite
	| PY243_FOR exprlist PY243_IN testlist PY243_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY243_TRY PY243_COLON suite plus_except PY243_ELSE PY243_COLON suite
	| PY243_TRY PY243_COLON suite plus_except
	| PY243_TRY PY243_COLON suite PY243_FINALLY PY243_COLON suite
	;
except_clause // Used in: plus_except
	: PY243_EXCEPT test PY243_COMMA test
	| PY243_EXCEPT test
	| PY243_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY243_NEWLINE PY243_INDENT plus_stmt PY243_DEDENT
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, except_clause, listmaker, testlist_gexp, lambdef, subscript, sliceop, testlist, testlist_safe, dictmaker, arglist, argument, list_if, gen_for, gen_if, testlist1, star_fpdef_COMMA, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: and_test star_OR_and_test
	| lambdef
	;
and_test // Used in: test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY243_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY243_LESS
	| PY243_GREATER
	| PY243_EQEQUAL
	| PY243_GREATEREQUAL
	| PY243_LESSEQUAL
	| PY243_GRLT
	| PY243_NOTEQUAL
	| PY243_IN
	| PY243_NOT PY243_IN
	| PY243_IS
	| PY243_IS PY243_NOT
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
	: PY243_PLUS factor
	| PY243_MINUS factor
	| PY243_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY243_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY243_LPAR testlist_gexp PY243_RPAR
	| PY243_LPAR PY243_RPAR
	| PY243_LSQB listmaker PY243_RSQB
	| PY243_LSQB PY243_RSQB
	| PY243_LBRACE dictmaker PY243_RBRACE
	| PY243_LBRACE PY243_RBRACE
	| PY243_BACKQUOTE testlist1 PY243_BACKQUOTE
	| PY243_NAME
	| PY243_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY243_COMMA
	| test star_COMMA_test
	;
testlist_gexp // Used in: atom
	: test gen_for
	| test star_COMMA_test PY243_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY243_LAMBDA varargslist PY243_COLON test
	| PY243_LAMBDA PY243_COLON test
	;
trailer // Used in: star_trailer
	: PY243_LPAR arglist PY243_RPAR
	| PY243_LPAR PY243_RPAR
	| PY243_LSQB subscriptlist PY243_RSQB
	| PY243_DOT PY243_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY243_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY243_DOT PY243_DOT PY243_DOT
	| test
	| test PY243_COLON test sliceop
	| test PY243_COLON test
	| test PY243_COLON sliceop
	| test PY243_COLON
	| PY243_COLON test sliceop
	| PY243_COLON test
	| PY243_COLON sliceop
	| PY243_COLON
	;
sliceop // Used in: subscript
	: PY243_COLON test
	| PY243_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for, gen_for
	: expr star_COMMA_expr PY243_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, yield_stmt, for_stmt, classdef, star_EQUAL_testlist
	: test star_COMMA_test PY243_COMMA
	| test star_COMMA_test
	;
testlist_safe // Used in: list_for
	: test plus_COMMA_test PY243_COMMA
	| test plus_COMMA_test
	| test
	;
dictmaker // Used in: atom
	: test PY243_COLON test star_test_COLON_test PY243_COMMA
	| test PY243_COLON test star_test_COLON_test
	;
classdef // Used in: compound_stmt
	: PY243_CLASS PY243_NAME PY243_LPAR testlist PY243_RPAR PY243_COLON suite
	| PY243_CLASS PY243_NAME PY243_COLON suite
	;
arglist // Used in: decorator, trailer
	: star_argument_COMMA argument PY243_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY243_STAR test PY243_COMMA PY243_DOUBLESTAR test
	| star_argument_COMMA PY243_STAR test
	| star_argument_COMMA PY243_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA
	: test gen_for
	| test
	| test PY243_EQUAL test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY243_FOR exprlist PY243_IN testlist_safe list_iter
	| PY243_FOR exprlist PY243_IN testlist_safe
	;
list_if // Used in: list_iter
	: PY243_IF test list_iter
	| PY243_IF test
	;
gen_iter // Used in: gen_for, gen_if
	: gen_for
	| gen_if
	;
gen_for // Used in: testlist_gexp, argument, gen_iter
	: PY243_FOR exprlist PY243_IN test gen_iter
	| PY243_FOR exprlist PY243_IN test
	;
gen_if // Used in: gen_iter
	: PY243_IF test gen_iter
	| PY243_IF test
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY243_EQUAL test PY243_COMMA
	| star_fpdef_COMMA fpdef PY243_COMMA
	| %empty
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY243_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY243_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY243_SEMI small_stmt
	| %empty
	;
star_EQUAL_testlist // Used in: expr_stmt, star_EQUAL_testlist
	: star_EQUAL_testlist PY243_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist_gexp, testlist, testlist1, star_COMMA_test
	: star_COMMA_test PY243_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, testlist_safe, plus_COMMA_test
	: plus_COMMA_test PY243_COMMA test
	| PY243_COMMA test
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY243_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY243_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY243_DOT PY243_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY243_COMMA PY243_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY243_ELIF test PY243_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY243_COLON suite
	| except_clause PY243_COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: test, star_OR_and_test
	: star_OR_and_test PY243_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY243_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY243_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY243_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY243_AMPERSAND shift_expr
	| %empty
	;
star_001 // Used in: shift_expr, star_001
	: star_001 PY243_LEFTSHIFT arith_expr
	| star_001 PY243_RIGHTSHIFT arith_expr
	| %empty
	;
star_002 // Used in: arith_expr, star_002
	: star_002 PY243_PLUS term
	| star_002 PY243_MINUS term
	| %empty
	;
star_003 // Used in: term, star_003
	: star_003 PY243_STAR factor
	| star_003 PY243_SLASH factor
	| star_003 PY243_PERCENT factor
	| star_003 PY243_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY243_STRING
	| PY243_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY243_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY243_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictmaker, star_test_COLON_test
	: star_test_COLON_test PY243_COMMA test PY243_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY243_COMMA
	| %empty
	;

%%

void py243error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}

