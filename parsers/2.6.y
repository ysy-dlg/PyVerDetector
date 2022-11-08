%define api.push-pull push
%define api.pure full
%define api.prefix {py26}
%define parse.error verbose
%parse-param{TokenState* t_state}

%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "2.6.tab.h"
}
%code {
void py26error(TokenState* t_state, const char* msg);
}

// 83 tokens, in alphabetical order:
%token PY26_AMPEREQUAL PY26_AMPERSAND PY26_AND PY26_AS PY26_ASSERT PY26_AT PY26_BACKQUOTE PY26_BAR PY26_BREAK PY26_CIRCUMFLEX
%token PY26_CIRCUMFLEXEQUAL PY26_CLASS PY26_COLON PY26_COMMA PY26_CONTINUE PY26_DEDENT PY26_DEF PY26_DEL PY26_DOT PY26_DOUBLESLASH
%token PY26_DOUBLESLASHEQUAL PY26_DOUBLESTAR PY26_DOUBLESTAREQUAL PY26_ELIF PY26_ELSE PY26_ENDMARKER PY26_EQEQUAL
%token PY26_EQUAL PY26_EXCEPT PY26_EXEC PY26_FINALLY PY26_FOR PY26_FROM PY26_GLOBAL PY26_GREATER PY26_GREATEREQUAL PY26_GRLT
%token PY26_IF PY26_IMPORT PY26_IN PY26_INDENT PY26_IS PY26_LAMBDA PY26_LBRACE PY26_LEFTSHIFT PY26_LEFTSHIFTEQUAL PY26_LESS
%token PY26_LESSEQUAL PY26_LPAR PY26_LSQB PY26_MINEQUAL PY26_MINUS PY26_NAME PY26_NEWLINE PY26_NOT PY26_NOTEQUAL PY26_NUMBER
%token PY26_OR PY26_PASS PY26_PERCENT PY26_PERCENTEQUAL PY26_PLUS PY26_PLUSEQUAL PY26_PRINT PY26_RAISE PY26_RBRACE PY26_RETURN
%token PY26_RIGHTSHIFT PY26_RIGHTSHIFTEQUAL PY26_RPAR PY26_RSQB PY26_SEMI PY26_SLASH PY26_SLASHEQUAL PY26_STAR PY26_STAREQUAL
%token PY26_STRING PY26_TILDE PY26_TRY PY26_VBAREQUAL PY26_WHILE PY26_WITH PY26_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY26_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY26_AT dotted_name PY26_LPAR arglist PY26_RPAR PY26_NEWLINE
	| PY26_AT dotted_name PY26_LPAR PY26_RPAR PY26_NEWLINE
	| PY26_AT dotted_name PY26_NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	;
funcdef // Used in: decorated, compound_stmt
	: PY26_DEF PY26_NAME parameters PY26_COLON suite
	;
parameters // Used in: funcdef
	: PY26_LPAR varargslist PY26_RPAR
	| PY26_LPAR PY26_RPAR
	;
varargslist // Used in: parameters, old_lambdef, lambdef
	: star_fpdef_COMMA PY26_STAR PY26_NAME PY26_COMMA PY26_DOUBLESTAR PY26_NAME
	| star_fpdef_COMMA PY26_STAR PY26_NAME
	| star_fpdef_COMMA PY26_DOUBLESTAR PY26_NAME
	| star_fpdef_COMMA fpdef PY26_EQUAL test PY26_COMMA
	| star_fpdef_COMMA fpdef PY26_EQUAL test
	| star_fpdef_COMMA fpdef PY26_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY26_NAME
	| PY26_LPAR fplist PY26_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY26_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY26_SEMI PY26_NEWLINE
	| small_stmt star_SEMI_small_stmt PY26_NEWLINE
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
	: PY26_PLUSEQUAL
	| PY26_MINEQUAL
	| PY26_STAREQUAL
	| PY26_SLASHEQUAL
	| PY26_PERCENTEQUAL
	| PY26_AMPEREQUAL
	| PY26_VBAREQUAL
	| PY26_CIRCUMFLEXEQUAL
	| PY26_LEFTSHIFTEQUAL
	| PY26_RIGHTSHIFTEQUAL
	| PY26_DOUBLESTAREQUAL
	| PY26_DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PY26_PRINT test star_COMMA_test PY26_COMMA
	| PY26_PRINT test star_COMMA_test
	| PY26_PRINT
	| PY26_PRINT PY26_RIGHTSHIFT test plus_COMMA_test PY26_COMMA
	| PY26_PRINT PY26_RIGHTSHIFT test plus_COMMA_test
	| PY26_PRINT PY26_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY26_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY26_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY26_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY26_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY26_RETURN testlist
	| PY26_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY26_RAISE test PY26_COMMA test PY26_COMMA test
	| PY26_RAISE test PY26_COMMA test
	| PY26_RAISE test
	| PY26_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY26_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY26_FROM star_DOT dotted_name PY26_IMPORT PY26_STAR
	| PY26_FROM star_DOT dotted_name PY26_IMPORT PY26_LPAR import_as_names PY26_RPAR
	| PY26_FROM star_DOT dotted_name PY26_IMPORT import_as_names
	| PY26_FROM star_DOT PY26_DOT PY26_IMPORT PY26_STAR
	| PY26_FROM star_DOT PY26_DOT PY26_IMPORT PY26_LPAR import_as_names PY26_RPAR
	| PY26_FROM star_DOT PY26_DOT PY26_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY26_NAME PY26_AS PY26_NAME
	| PY26_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY26_AS PY26_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY26_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY26_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY26_GLOBAL PY26_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY26_EXEC expr PY26_IN test PY26_COMMA test
	| PY26_EXEC expr PY26_IN test
	| PY26_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY26_ASSERT test PY26_COMMA test
	| PY26_ASSERT test
	;
compound_stmt // Used in: stmt
	: if_stmt
	| while_stmt
	| for_stmt
	| try_stmt
	| with_stmt
	| funcdef
	| classdef
	| decorated
	;
if_stmt // Used in: compound_stmt
	: PY26_IF test PY26_COLON suite star_ELIF PY26_ELSE PY26_COLON suite
	| PY26_IF test PY26_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY26_WHILE test PY26_COLON suite PY26_ELSE PY26_COLON suite
	| PY26_WHILE test PY26_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY26_FOR exprlist PY26_IN testlist PY26_COLON suite PY26_ELSE PY26_COLON suite
	| PY26_FOR exprlist PY26_IN testlist PY26_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY26_TRY PY26_COLON suite plus_except PY26_ELSE PY26_COLON suite PY26_FINALLY PY26_COLON suite
	| PY26_TRY PY26_COLON suite plus_except PY26_ELSE PY26_COLON suite
	| PY26_TRY PY26_COLON suite plus_except PY26_FINALLY PY26_COLON suite
	| PY26_TRY PY26_COLON suite plus_except
	| PY26_TRY PY26_COLON suite PY26_FINALLY PY26_COLON suite
	;
with_stmt // Used in: compound_stmt
	: PY26_WITH test with_var PY26_COLON suite
	| PY26_WITH test PY26_COLON suite
	;
with_var // Used in: with_stmt
	: PY26_AS expr
	;
except_clause // Used in: plus_except
	: PY26_EXCEPT test PY26_AS test
	| PY26_EXCEPT test PY26_COMMA test
	| PY26_EXCEPT test
	| PY26_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY26_NEWLINE PY26_INDENT plus_stmt PY26_DEDENT
	;
testlist_safe // Used in: list_for
	: old_test plus_COMMA_old_test PY26_COMMA
	| old_test plus_COMMA_old_test
	| old_test
	;
old_test // Used in: testlist_safe, old_lambdef, list_if, gen_if, plus_COMMA_old_test
	: or_test
	| old_lambdef
	;
old_lambdef // Used in: old_test
	: PY26_LAMBDA varargslist PY26_COLON old_test
	| PY26_LAMBDA PY26_COLON old_test
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, with_stmt, except_clause, test, listmaker, testlist_gexp, lambdef, subscript, sliceop, testlist, dictmaker, arglist, argument, testlist1, star_fpdef_COMMA, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: or_test PY26_IF or_test PY26_ELSE test
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
	: PY26_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY26_LESS
	| PY26_GREATER
	| PY26_EQEQUAL
	| PY26_GREATEREQUAL
	| PY26_LESSEQUAL
	| PY26_GRLT
	| PY26_NOTEQUAL
	| PY26_IN
	| PY26_NOT PY26_IN
	| PY26_IS
	| PY26_IS PY26_NOT
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
	: PY26_PLUS factor
	| PY26_MINUS factor
	| PY26_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY26_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY26_LPAR yield_expr PY26_RPAR
	| PY26_LPAR testlist_gexp PY26_RPAR
	| PY26_LPAR PY26_RPAR
	| PY26_LSQB listmaker PY26_RSQB
	| PY26_LSQB PY26_RSQB
	| PY26_LBRACE dictmaker PY26_RBRACE
	| PY26_LBRACE PY26_RBRACE
	| PY26_BACKQUOTE testlist1 PY26_BACKQUOTE
	| PY26_NAME
	| PY26_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY26_COMMA
	| test star_COMMA_test
	;
testlist_gexp // Used in: atom
	: test gen_for
	| test star_COMMA_test PY26_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY26_LAMBDA varargslist PY26_COLON test
	| PY26_LAMBDA PY26_COLON test
	;
trailer // Used in: star_trailer
	: PY26_LPAR arglist PY26_RPAR
	| PY26_LPAR PY26_RPAR
	| PY26_LSQB subscriptlist PY26_RSQB
	| PY26_DOT PY26_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY26_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY26_DOT PY26_DOT PY26_DOT
	| test
	| test PY26_COLON test sliceop
	| test PY26_COLON test
	| test PY26_COLON sliceop
	| test PY26_COLON
	| PY26_COLON test sliceop
	| PY26_COLON test
	| PY26_COLON sliceop
	| PY26_COLON
	;
sliceop // Used in: subscript
	: PY26_COLON test
	| PY26_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for, gen_for
	: expr star_COMMA_expr PY26_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, classdef, yield_expr, star_001
	: test star_COMMA_test PY26_COMMA
	| test star_COMMA_test
	;
dictmaker // Used in: atom
	: test PY26_COLON test star_test_COLON_test PY26_COMMA
	| test PY26_COLON test star_test_COLON_test
	;
classdef // Used in: decorated, compound_stmt
	: PY26_CLASS PY26_NAME PY26_LPAR testlist PY26_RPAR PY26_COLON suite
	| PY26_CLASS PY26_NAME PY26_LPAR PY26_RPAR PY26_COLON suite
	| PY26_CLASS PY26_NAME PY26_COLON suite
	;
arglist // Used in: decorator, trailer
	: star_argument_COMMA argument PY26_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY26_STAR test star_COMMA_argument PY26_COMMA PY26_DOUBLESTAR test
	| star_argument_COMMA PY26_STAR test star_COMMA_argument
	| star_argument_COMMA PY26_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA, star_COMMA_argument
	: test gen_for
	| test
	| test PY26_EQUAL test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY26_FOR exprlist PY26_IN testlist_safe list_iter
	| PY26_FOR exprlist PY26_IN testlist_safe
	;
list_if // Used in: list_iter
	: PY26_IF old_test list_iter
	| PY26_IF old_test
	;
gen_iter // Used in: gen_for, gen_if
	: gen_for
	| gen_if
	;
gen_for // Used in: testlist_gexp, argument, gen_iter
	: PY26_FOR exprlist PY26_IN or_test gen_iter
	| PY26_FOR exprlist PY26_IN or_test
	;
gen_if // Used in: gen_iter
	: PY26_IF old_test gen_iter
	| PY26_IF old_test
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_001
	: PY26_YIELD testlist
	| PY26_YIELD
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY26_EQUAL test PY26_COMMA
	| star_fpdef_COMMA fpdef PY26_COMMA
	| %empty
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY26_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY26_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY26_SEMI small_stmt
	| %empty
	;
star_001 // Used in: expr_stmt, star_001
	: star_001 PY26_EQUAL yield_expr
	| star_001 PY26_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist_gexp, testlist, testlist1, star_COMMA_test
	: star_COMMA_test PY26_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, plus_COMMA_test
	: plus_COMMA_test PY26_COMMA test
	| PY26_COMMA test
	;
star_DOT // Used in: import_from, star_DOT
	: star_DOT PY26_DOT
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY26_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY26_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY26_DOT PY26_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY26_COMMA PY26_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY26_ELIF test PY26_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY26_COLON suite
	| except_clause PY26_COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
plus_COMMA_old_test // Used in: testlist_safe, plus_COMMA_old_test
	: plus_COMMA_old_test PY26_COMMA old_test
	| PY26_COMMA old_test
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY26_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY26_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY26_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY26_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY26_AMPERSAND shift_expr
	| %empty
	;
star_002 // Used in: shift_expr, star_002
	: star_002 PY26_LEFTSHIFT arith_expr
	| star_002 PY26_RIGHTSHIFT arith_expr
	| %empty
	;
star_003 // Used in: arith_expr, star_003
	: star_003 PY26_PLUS term
	| star_003 PY26_MINUS term
	| %empty
	;
star_004 // Used in: term, star_004
	: star_004 PY26_STAR factor
	| star_004 PY26_SLASH factor
	| star_004 PY26_PERCENT factor
	| star_004 PY26_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY26_STRING
	| PY26_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY26_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY26_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictmaker, star_test_COLON_test
	: star_test_COLON_test PY26_COMMA test PY26_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY26_COMMA
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY26_COMMA argument
	| %empty
	;

%%

void py26error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
