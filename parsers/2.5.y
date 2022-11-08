%define api.push-pull push
%define api.pure full
%define api.prefix {py25}
%define parse.error verbose
%parse-param{TokenState* t_state}

%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "2.5.tab.h"
}
%code {
void py25error(TokenState* t_state, const char* msg);
}

// 83 tokens, in alphabetical order:
%token PY25_AMPEREQUAL PY25_AMPERSAND PY25_AND PY25_AS PY25_ASSERT PY25_AT PY25_BACKQUOTE PY25_BAR PY25_BREAK PY25_CIRCUMFLEX
%token PY25_CIRCUMFLEXEQUAL PY25_CLASS PY25_COLON PY25_COMMA PY25_CONTINUE PY25_DEDENT PY25_DEF PY25_DEL PY25_DOT PY25_DOUBLESLASH
%token PY25_DOUBLESLASHEQUAL PY25_DOUBLESTAR PY25_DOUBLESTAREQUAL PY25_ELIF PY25_ELSE PY25_ENDMARKER PY25_EQEQUAL
%token PY25_EQUAL PY25_EXCEPT PY25_EXEC PY25_FINALLY PY25_FOR PY25_FROM PY25_GLOBAL PY25_GREATER PY25_GREATEREQUAL PY25_GRLT
%token PY25_IF PY25_IMPORT PY25_IN PY25_INDENT PY25_IS PY25_LAMBDA PY25_LBRACE PY25_LEFTSHIFT PY25_LEFTSHIFTEQUAL PY25_LESS
%token PY25_LESSEQUAL PY25_LPAR PY25_LSQB PY25_MINEQUAL PY25_MINUS PY25_NAME PY25_NEWLINE PY25_NOT PY25_NOTEQUAL PY25_NUMBER
%token PY25_OR PY25_PASS PY25_PERCENT PY25_PERCENTEQUAL PY25_PLUS PY25_PLUSEQUAL PY25_PRINT PY25_RAISE PY25_RBRACE PY25_RETURN
%token PY25_RIGHTSHIFT PY25_RIGHTSHIFTEQUAL PY25_RPAR PY25_RSQB PY25_SEMI PY25_SLASH PY25_SLASHEQUAL PY25_STAR PY25_STAREQUAL
%token PY25_STRING PY25_TILDE PY25_TRY PY25_VBAREQUAL PY25_WHILE PY25_WITH PY25_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY25_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY25_AT dotted_name PY25_LPAR arglist PY25_RPAR PY25_NEWLINE
	| PY25_AT dotted_name PY25_LPAR PY25_RPAR PY25_NEWLINE
	| PY25_AT dotted_name PY25_NEWLINE
	;
decorators // Used in: funcdef
	: plus_decorator
	;
funcdef // Used in: compound_stmt
	: decorators PY25_DEF PY25_NAME parameters PY25_COLON suite
	| PY25_DEF PY25_NAME parameters PY25_COLON suite
	;
parameters // Used in: funcdef
	: PY25_LPAR varargslist PY25_RPAR
	| PY25_LPAR PY25_RPAR
	;
varargslist // Used in: parameters, old_lambdef, lambdef
	: star_fpdef_COMMA PY25_STAR PY25_NAME PY25_COMMA PY25_DOUBLESTAR PY25_NAME
	| star_fpdef_COMMA PY25_STAR PY25_NAME
	| star_fpdef_COMMA PY25_DOUBLESTAR PY25_NAME
	| star_fpdef_COMMA fpdef PY25_EQUAL test PY25_COMMA
	| star_fpdef_COMMA fpdef PY25_EQUAL test
	| star_fpdef_COMMA fpdef PY25_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY25_NAME
	| PY25_LPAR fplist PY25_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY25_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY25_SEMI PY25_NEWLINE
	| small_stmt star_SEMI_small_stmt PY25_NEWLINE
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
	: testlist augassign yield_expr
	| testlist augassign testlist
	| testlist star_001
	;
augassign // Used in: expr_stmt
	: PY25_PLUSEQUAL
	| PY25_MINEQUAL
	| PY25_STAREQUAL
	| PY25_SLASHEQUAL
	| PY25_PERCENTEQUAL
	| PY25_AMPEREQUAL
	| PY25_VBAREQUAL
	| PY25_CIRCUMFLEXEQUAL
	| PY25_LEFTSHIFTEQUAL
	| PY25_RIGHTSHIFTEQUAL
	| PY25_DOUBLESTAREQUAL
	| PY25_DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PY25_PRINT test star_COMMA_test PY25_COMMA
	| PY25_PRINT test star_COMMA_test
	| PY25_PRINT
	| PY25_PRINT PY25_RIGHTSHIFT test plus_COMMA_test PY25_COMMA
	| PY25_PRINT PY25_RIGHTSHIFT test plus_COMMA_test
	| PY25_PRINT PY25_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY25_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY25_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY25_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY25_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY25_RETURN testlist
	| PY25_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY25_RAISE test PY25_COMMA test PY25_COMMA test
	| PY25_RAISE test PY25_COMMA test
	| PY25_RAISE test
	| PY25_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY25_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY25_FROM star_DOT dotted_name PY25_IMPORT PY25_STAR
	| PY25_FROM star_DOT dotted_name PY25_IMPORT PY25_LPAR import_as_names PY25_RPAR
	| PY25_FROM star_DOT dotted_name PY25_IMPORT import_as_names
	| PY25_FROM star_DOT PY25_DOT PY25_IMPORT PY25_STAR
	| PY25_FROM star_DOT PY25_DOT PY25_IMPORT PY25_LPAR import_as_names PY25_RPAR
	| PY25_FROM star_DOT PY25_DOT PY25_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY25_NAME PY25_AS PY25_NAME
	| PY25_NAME PY25_NAME PY25_NAME
	| PY25_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY25_AS PY25_NAME
	| dotted_name PY25_NAME PY25_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY25_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY25_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY25_GLOBAL PY25_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY25_EXEC expr PY25_IN test PY25_COMMA test
	| PY25_EXEC expr PY25_IN test
	| PY25_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY25_ASSERT test PY25_COMMA test
	| PY25_ASSERT test
	;
compound_stmt // Used in: stmt
	: if_stmt
	| while_stmt
	| for_stmt
	| try_stmt
	| with_stmt
	| funcdef
	| classdef
	;
if_stmt // Used in: compound_stmt
	: PY25_IF test PY25_COLON suite star_ELIF PY25_ELSE PY25_COLON suite
	| PY25_IF test PY25_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY25_WHILE test PY25_COLON suite PY25_ELSE PY25_COLON suite
	| PY25_WHILE test PY25_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY25_FOR exprlist PY25_IN testlist PY25_COLON suite PY25_ELSE PY25_COLON suite
	| PY25_FOR exprlist PY25_IN testlist PY25_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY25_TRY PY25_COLON suite plus_except PY25_ELSE PY25_COLON suite PY25_FINALLY PY25_COLON suite
	| PY25_TRY PY25_COLON suite plus_except PY25_ELSE PY25_COLON suite
	| PY25_TRY PY25_COLON suite plus_except PY25_FINALLY PY25_COLON suite
	| PY25_TRY PY25_COLON suite plus_except
	| PY25_TRY PY25_COLON suite PY25_FINALLY PY25_COLON suite
	;
with_stmt // Used in: compound_stmt
	: PY25_WITH test with_var PY25_COLON suite
	| PY25_WITH test PY25_COLON suite
	;
with_var // Used in: with_stmt
	: PY25_AS expr
	| PY25_NAME expr
	;
except_clause // Used in: plus_except
	: PY25_EXCEPT test PY25_COMMA test
	| PY25_EXCEPT test
	| PY25_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY25_NEWLINE PY25_INDENT plus_stmt PY25_DEDENT
	;
testlist_safe // Used in: list_for
	: old_test plus_COMMA_old_test PY25_COMMA
	| old_test plus_COMMA_old_test
	| old_test
	;
old_test // Used in: testlist_safe, old_lambdef, list_if, gen_if, plus_COMMA_old_test
	: or_test
	| old_lambdef
	;
old_lambdef // Used in: old_test
	: PY25_LAMBDA varargslist PY25_COLON old_test
	| PY25_LAMBDA PY25_COLON old_test
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, with_stmt, except_clause, test, listmaker, testlist_gexp, lambdef, subscript, sliceop, testlist, dictmaker, arglist, argument, testlist1, star_fpdef_COMMA, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: or_test PY25_IF or_test PY25_ELSE test
	| or_test
	| lambdef
	;
or_test // Used in: old_test, test, gen_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY25_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY25_LESS
	| PY25_GREATER
	| PY25_EQEQUAL
	| PY25_GREATEREQUAL
	| PY25_LESSEQUAL
	| PY25_GRLT
	| PY25_NOTEQUAL
	| PY25_IN
	| PY25_NOT PY25_IN
	| PY25_IS
	| PY25_IS PY25_NOT
	;
expr // Used in: exec_stmt, with_var, comparison, exprlist, star_comp_op_expr, star_COMMA_expr
	: xor_expr star_BAR_xor_expr
	;
xor_expr // Used in: expr, star_BAR_xor_expr
	: and_expr star_CIRCUMFLEX_and_expr
	;
and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: shift_expr star_AMPERSAND_shift_expr
	;
shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: arith_expr star_002
	;
arith_expr // Used in: shift_expr, star_002
	: term star_003
	;
term // Used in: arith_expr, star_003
	: factor star_004
	;
factor // Used in: term, factor, power, star_004
	: PY25_PLUS factor
	| PY25_MINUS factor
	| PY25_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY25_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY25_LPAR yield_expr PY25_RPAR
	| PY25_LPAR testlist_gexp PY25_RPAR
	| PY25_LPAR PY25_RPAR
	| PY25_LSQB listmaker PY25_RSQB
	| PY25_LSQB PY25_RSQB
	| PY25_LBRACE dictmaker PY25_RBRACE
	| PY25_LBRACE PY25_RBRACE
	| PY25_BACKQUOTE testlist1 PY25_BACKQUOTE
	| PY25_NAME
	| PY25_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY25_COMMA
	| test star_COMMA_test
	;
testlist_gexp // Used in: atom
	: test gen_for
	| test star_COMMA_test PY25_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY25_LAMBDA varargslist PY25_COLON test
	| PY25_LAMBDA PY25_COLON test
	;
trailer // Used in: star_trailer
	: PY25_LPAR arglist PY25_RPAR
	| PY25_LPAR PY25_RPAR
	| PY25_LSQB subscriptlist PY25_RSQB
	| PY25_DOT PY25_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY25_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY25_DOT PY25_DOT PY25_DOT
	| test
	| test PY25_COLON test sliceop
	| test PY25_COLON test
	| test PY25_COLON sliceop
	| test PY25_COLON
	| PY25_COLON test sliceop
	| PY25_COLON test
	| PY25_COLON sliceop
	| PY25_COLON
	;
sliceop // Used in: subscript
	: PY25_COLON test
	| PY25_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for, gen_for
	: expr star_COMMA_expr PY25_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, classdef, yield_expr, star_001
	: test star_COMMA_test PY25_COMMA
	| test star_COMMA_test
	;
dictmaker // Used in: atom
	: test PY25_COLON test star_test_COLON_test PY25_COMMA
	| test PY25_COLON test star_test_COLON_test
	;
classdef // Used in: compound_stmt
	: PY25_CLASS PY25_NAME PY25_LPAR testlist PY25_RPAR PY25_COLON suite
	| PY25_CLASS PY25_NAME PY25_LPAR PY25_RPAR PY25_COLON suite
	| PY25_CLASS PY25_NAME PY25_COLON suite
	;
arglist // Used in: decorator, trailer
	: star_argument_COMMA argument PY25_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY25_STAR test PY25_COMMA PY25_DOUBLESTAR test
	| star_argument_COMMA PY25_STAR test
	| star_argument_COMMA PY25_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA
	: test gen_for
	| test
	| test PY25_EQUAL test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY25_FOR exprlist PY25_IN testlist_safe list_iter
	| PY25_FOR exprlist PY25_IN testlist_safe
	;
list_if // Used in: list_iter
	: PY25_IF old_test list_iter
	| PY25_IF old_test
	;
gen_iter // Used in: gen_for, gen_if
	: gen_for
	| gen_if
	;
gen_for // Used in: testlist_gexp, argument, gen_iter
	: PY25_FOR exprlist PY25_IN or_test gen_iter
	| PY25_FOR exprlist PY25_IN or_test
	;
gen_if // Used in: gen_iter
	: PY25_IF old_test gen_iter
	| PY25_IF old_test
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_001
	: PY25_YIELD testlist
	| PY25_YIELD
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY25_EQUAL test PY25_COMMA
	| star_fpdef_COMMA fpdef PY25_COMMA
	| %empty
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY25_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY25_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY25_SEMI small_stmt
	| %empty
	;
star_001 // Used in: expr_stmt, star_001
	: star_001 PY25_EQUAL yield_expr
	| star_001 PY25_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist_gexp, testlist, testlist1, star_COMMA_test
	: star_COMMA_test PY25_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, plus_COMMA_test
	: plus_COMMA_test PY25_COMMA test
	| PY25_COMMA test
	;
star_DOT // Used in: import_from, star_DOT
	: star_DOT PY25_DOT
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY25_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY25_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY25_DOT PY25_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY25_COMMA PY25_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY25_ELIF test PY25_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY25_COLON suite
	| except_clause PY25_COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
plus_COMMA_old_test // Used in: testlist_safe, plus_COMMA_old_test
	: plus_COMMA_old_test PY25_COMMA old_test
	| PY25_COMMA old_test
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY25_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY25_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY25_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY25_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY25_AMPERSAND shift_expr
	| %empty
	;
star_002 // Used in: shift_expr, star_002
	: star_002 PY25_LEFTSHIFT arith_expr
	| star_002 PY25_RIGHTSHIFT arith_expr
	| %empty
	;
star_003 // Used in: arith_expr, star_003
	: star_003 PY25_PLUS term
	| star_003 PY25_MINUS term
	| %empty
	;
star_004 // Used in: term, star_004
	: star_004 PY25_STAR factor
	| star_004 PY25_SLASH factor
	| star_004 PY25_PERCENT factor
	| star_004 PY25_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY25_STRING
	| PY25_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY25_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY25_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictmaker, star_test_COLON_test
	: star_test_COLON_test PY25_COMMA test PY25_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY25_COMMA
	| %empty
	;

%%

void py25error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
