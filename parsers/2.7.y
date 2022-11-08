%define api.push-pull push
%define api.pure full
%define api.prefix {py27}
%define parse.error verbose
%parse-param{TokenState* t_state}

%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "2.7.tab.h"
}
%code {
void py27error(TokenState* t_state, const char* msg);
}

// 83 tokens, in alphabetical order:
%token PY27_AMPEREQUAL PY27_AMPERSAND PY27_AND PY27_AS PY27_ASSERT PY27_AT PY27_BACKQUOTE PY27_BAR PY27_BREAK PY27_CIRCUMFLEX
%token PY27_CIRCUMFLEXEQUAL PY27_CLASS PY27_COLON PY27_COMMA PY27_CONTINUE PY27_DEDENT PY27_DEF PY27_DEL PY27_DOT PY27_DOUBLESLASH
%token PY27_DOUBLESLASHEQUAL PY27_DOUBLESTAR PY27_DOUBLESTAREQUAL PY27_ELIF PY27_ELSE PY27_ENDMARKER PY27_EQEQUAL
%token PY27_EQUAL PY27_EXCEPT PY27_EXEC PY27_FINALLY PY27_FOR PY27_FROM PY27_GLOBAL PY27_GREATER PY27_GREATEREQUAL PY27_GRLT
%token PY27_IF PY27_IMPORT PY27_IN PY27_INDENT PY27_IS PY27_LAMBDA PY27_LBRACE PY27_LEFTSHIFT PY27_LEFTSHIFTEQUAL PY27_LESS
%token PY27_LESSEQUAL PY27_LPAR PY27_LSQB PY27_MINEQUAL PY27_MINUS PY27_NAME PY27_NEWLINE PY27_NOT PY27_NOTEQUAL PY27_NUMBER
%token PY27_OR PY27_PASS PY27_PERCENT PY27_PERCENTEQUAL PY27_PLUS PY27_PLUSEQUAL PY27_PRINT PY27_RAISE PY27_RBRACE PY27_RETURN
%token PY27_RIGHTSHIFT PY27_RIGHTSHIFTEQUAL PY27_RPAR PY27_RSQB PY27_SEMI PY27_SLASH PY27_SLASHEQUAL PY27_STAR PY27_STAREQUAL
%token PY27_STRING PY27_TILDE PY27_TRY PY27_VBAREQUAL PY27_WHILE PY27_WITH PY27_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY27_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY27_AT dotted_name PY27_LPAR arglist PY27_RPAR PY27_NEWLINE
	| PY27_AT dotted_name PY27_LPAR PY27_RPAR PY27_NEWLINE
	| PY27_AT dotted_name PY27_NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	;
funcdef // Used in: decorated, compound_stmt
	: PY27_DEF PY27_NAME parameters PY27_COLON suite
	;
parameters // Used in: funcdef
	: PY27_LPAR varargslist PY27_RPAR
	| PY27_LPAR PY27_RPAR
	;
varargslist // Used in: parameters, old_lambdef, lambdef
	: star_fpdef_COMMA PY27_STAR PY27_NAME PY27_COMMA PY27_DOUBLESTAR PY27_NAME
	| star_fpdef_COMMA PY27_STAR PY27_NAME
	| star_fpdef_COMMA PY27_DOUBLESTAR PY27_NAME
	| star_fpdef_COMMA fpdef PY27_EQUAL test PY27_COMMA
	| star_fpdef_COMMA fpdef PY27_EQUAL test
	| star_fpdef_COMMA fpdef PY27_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY27_NAME
	| PY27_LPAR fplist PY27_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY27_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY27_SEMI PY27_NEWLINE
	| small_stmt star_SEMI_small_stmt PY27_NEWLINE
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
	: PY27_PLUSEQUAL
	| PY27_MINEQUAL
	| PY27_STAREQUAL
	| PY27_SLASHEQUAL
	| PY27_PERCENTEQUAL
	| PY27_AMPEREQUAL
	| PY27_VBAREQUAL
	| PY27_CIRCUMFLEXEQUAL
	| PY27_LEFTSHIFTEQUAL
	| PY27_RIGHTSHIFTEQUAL
	| PY27_DOUBLESTAREQUAL
	| PY27_DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PY27_PRINT test star_COMMA_test PY27_COMMA
	| PY27_PRINT test star_COMMA_test
	| PY27_PRINT
	| PY27_PRINT PY27_RIGHTSHIFT test plus_COMMA_test PY27_COMMA
	| PY27_PRINT PY27_RIGHTSHIFT test plus_COMMA_test
	| PY27_PRINT PY27_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY27_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY27_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY27_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY27_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY27_RETURN testlist
	| PY27_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY27_RAISE test PY27_COMMA test PY27_COMMA test
	| PY27_RAISE test PY27_COMMA test
	| PY27_RAISE test
	| PY27_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY27_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY27_FROM star_DOT dotted_name PY27_IMPORT PY27_STAR
	| PY27_FROM star_DOT dotted_name PY27_IMPORT PY27_LPAR import_as_names PY27_RPAR
	| PY27_FROM star_DOT dotted_name PY27_IMPORT import_as_names
	| PY27_FROM star_DOT PY27_DOT PY27_IMPORT PY27_STAR
	| PY27_FROM star_DOT PY27_DOT PY27_IMPORT PY27_LPAR import_as_names PY27_RPAR
	| PY27_FROM star_DOT PY27_DOT PY27_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY27_NAME PY27_AS PY27_NAME
	| PY27_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY27_AS PY27_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY27_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY27_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY27_GLOBAL PY27_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY27_EXEC expr PY27_IN test PY27_COMMA test
	| PY27_EXEC expr PY27_IN test
	| PY27_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY27_ASSERT test PY27_COMMA test
	| PY27_ASSERT test
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
	: PY27_IF test PY27_COLON suite star_ELIF PY27_ELSE PY27_COLON suite
	| PY27_IF test PY27_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY27_WHILE test PY27_COLON suite PY27_ELSE PY27_COLON suite
	| PY27_WHILE test PY27_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY27_FOR exprlist PY27_IN testlist PY27_COLON suite PY27_ELSE PY27_COLON suite
	| PY27_FOR exprlist PY27_IN testlist PY27_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY27_TRY PY27_COLON suite plus_except PY27_ELSE PY27_COLON suite PY27_FINALLY PY27_COLON suite
	| PY27_TRY PY27_COLON suite plus_except PY27_ELSE PY27_COLON suite
	| PY27_TRY PY27_COLON suite plus_except PY27_FINALLY PY27_COLON suite
	| PY27_TRY PY27_COLON suite plus_except
	| PY27_TRY PY27_COLON suite PY27_FINALLY PY27_COLON suite
	;
with_stmt // Used in: compound_stmt
	: PY27_WITH with_item star_COMMA_with_item PY27_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY27_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY27_EXCEPT test PY27_AS test
	| PY27_EXCEPT test PY27_COMMA test
	| PY27_EXCEPT test
	| PY27_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY27_NEWLINE PY27_INDENT plus_stmt PY27_DEDENT
	;
testlist_safe // Used in: list_for
	: old_test plus_COMMA_old_test PY27_COMMA
	| old_test plus_COMMA_old_test
	| old_test
	;
old_test // Used in: testlist_safe, old_lambdef, list_if, comp_if, plus_COMMA_old_test
	: or_test
	| old_lambdef
	;
old_lambdef // Used in: old_test
	: PY27_LAMBDA varargslist PY27_COLON old_test
	| PY27_LAMBDA PY27_COLON old_test
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, listmaker, testlist_comp, lambdef, subscript, sliceop, testlist, dictorsetmaker, arglist, argument, testlist1, star_fpdef_COMMA, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: or_test PY27_IF or_test PY27_ELSE test
	| or_test
	| lambdef
	;
or_test // Used in: old_test, test, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY27_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY27_LESS
	| PY27_GREATER
	| PY27_EQEQUAL
	| PY27_GREATEREQUAL
	| PY27_LESSEQUAL
	| PY27_GRLT
	| PY27_NOTEQUAL
	| PY27_IN
	| PY27_NOT PY27_IN
	| PY27_IS
	| PY27_IS PY27_NOT
	;
expr // Used in: exec_stmt, with_item, comparison, exprlist, star_comp_op_expr, star_COMMA_expr
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
	: PY27_PLUS factor
	| PY27_MINUS factor
	| PY27_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY27_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY27_LPAR yield_expr PY27_RPAR
	| PY27_LPAR testlist_comp PY27_RPAR
	| PY27_LPAR PY27_RPAR
	| PY27_LSQB listmaker PY27_RSQB
	| PY27_LSQB PY27_RSQB
	| PY27_LBRACE dictorsetmaker PY27_RBRACE
	| PY27_LBRACE PY27_RBRACE
	| PY27_BACKQUOTE testlist1 PY27_BACKQUOTE
	| PY27_NAME
	| PY27_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY27_COMMA
	| test star_COMMA_test
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_COMMA_test PY27_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY27_LAMBDA varargslist PY27_COLON test
	| PY27_LAMBDA PY27_COLON test
	;
trailer // Used in: star_trailer
	: PY27_LPAR arglist PY27_RPAR
	| PY27_LPAR PY27_RPAR
	| PY27_LSQB subscriptlist PY27_RSQB
	| PY27_DOT PY27_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY27_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY27_DOT PY27_DOT PY27_DOT
	| test
	| test PY27_COLON test sliceop
	| test PY27_COLON test
	| test PY27_COLON sliceop
	| test PY27_COLON
	| PY27_COLON test sliceop
	| PY27_COLON test
	| PY27_COLON sliceop
	| PY27_COLON
	;
sliceop // Used in: subscript
	: PY27_COLON test
	| PY27_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for, comp_for
	: expr star_COMMA_expr PY27_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, classdef, yield_expr, star_001
	: test star_COMMA_test PY27_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY27_COLON test comp_for
	| test PY27_COLON test star_test_COLON_test PY27_COMMA
	| test PY27_COLON test star_test_COLON_test
	| test comp_for
	| test star_COMMA_test PY27_COMMA
	| test star_COMMA_test
	;
classdef // Used in: decorated, compound_stmt
	: PY27_CLASS PY27_NAME PY27_LPAR testlist PY27_RPAR PY27_COLON suite
	| PY27_CLASS PY27_NAME PY27_LPAR PY27_RPAR PY27_COLON suite
	| PY27_CLASS PY27_NAME PY27_COLON suite
	;
arglist // Used in: decorator, trailer
	: star_argument_COMMA argument PY27_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY27_STAR test star_COMMA_argument PY27_COMMA PY27_DOUBLESTAR test
	| star_argument_COMMA PY27_STAR test star_COMMA_argument
	| star_argument_COMMA PY27_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA, star_COMMA_argument
	: test comp_for
	| test
	| test PY27_EQUAL test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY27_FOR exprlist PY27_IN testlist_safe list_iter
	| PY27_FOR exprlist PY27_IN testlist_safe
	;
list_if // Used in: list_iter
	: PY27_IF old_test list_iter
	| PY27_IF old_test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY27_FOR exprlist PY27_IN or_test comp_iter
	| PY27_FOR exprlist PY27_IN or_test
	;
comp_if // Used in: comp_iter
	: PY27_IF old_test comp_iter
	| PY27_IF old_test
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_001
	: PY27_YIELD testlist
	| PY27_YIELD
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY27_EQUAL test PY27_COMMA
	| star_fpdef_COMMA fpdef PY27_COMMA
	| %empty
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY27_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY27_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY27_SEMI small_stmt
	| %empty
	;
star_001 // Used in: expr_stmt, star_001
	: star_001 PY27_EQUAL yield_expr
	| star_001 PY27_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist_comp, testlist, dictorsetmaker, testlist1, star_COMMA_test
	: star_COMMA_test PY27_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, plus_COMMA_test
	: plus_COMMA_test PY27_COMMA test
	| PY27_COMMA test
	;
star_DOT // Used in: import_from, star_DOT
	: star_DOT PY27_DOT
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY27_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY27_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY27_DOT PY27_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY27_COMMA PY27_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY27_ELIF test PY27_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY27_COLON suite
	| except_clause PY27_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY27_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
plus_COMMA_old_test // Used in: testlist_safe, plus_COMMA_old_test
	: plus_COMMA_old_test PY27_COMMA old_test
	| PY27_COMMA old_test
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY27_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY27_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY27_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY27_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY27_AMPERSAND shift_expr
	| %empty
	;
star_002 // Used in: shift_expr, star_002
	: star_002 PY27_LEFTSHIFT arith_expr
	| star_002 PY27_RIGHTSHIFT arith_expr
	| %empty
	;
star_003 // Used in: arith_expr, star_003
	: star_003 PY27_PLUS term
	| star_003 PY27_MINUS term
	| %empty
	;
star_004 // Used in: term, star_004
	: star_004 PY27_STAR factor
	| star_004 PY27_SLASH factor
	| star_004 PY27_PERCENT factor
	| star_004 PY27_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY27_STRING
	| PY27_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY27_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY27_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictorsetmaker, star_test_COLON_test
	: star_test_COLON_test PY27_COMMA test PY27_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY27_COMMA
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY27_COMMA argument
	| %empty
	;

%%

void py27error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
