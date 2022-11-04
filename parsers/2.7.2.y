%define api.push-pull push
%define api.pure full
%define api.prefix {py272}

%code top {
  #include <stdio.h>
  #include "2.7.2.tab.h"
}
%code {
void py272error(const char* msg);
}
// 83 tokens, in alphabetical order:
%token PY272_AMPEREQUAL PY272_AMPERSAND PY272_AND PY272_AS PY272_ASSERT PY272_AT PY272_BACKQUOTE PY272_BAR PY272_BREAK PY272_CIRCUMFLEX
%token PY272_CIRCUMFLEXEQUAL PY272_CLASS PY272_COLON PY272_COMMA PY272_CONTINUE PY272_DEDENT PY272_DEF PY272_DEL PY272_DOT PY272_DOUBLESLASH
%token PY272_DOUBLESLASHEQUAL PY272_DOUBLESTAR PY272_DOUBLESTAREQUAL PY272_ELIF PY272_ELSE PY272_ENDMARKER PY272_EQEQUAL
%token PY272_EQUAL PY272_EXCEPT PY272_EXEC PY272_FINALLY PY272_FOR PY272_FROM PY272_GLOBAL PY272_GREATER PY272_GREATEREQUAL PY272_GRLT
%token PY272_IF PY272_IMPORT PY272_IN PY272_INDENT PY272_IS PY272_LAMBDA PY272_LBRACE PY272_LEFTSHIFT PY272_LEFTSHIFTEQUAL PY272_LESS
%token PY272_LESSEQUAL PY272_LPAR PY272_LSQB PY272_MINEQUAL PY272_MINUS PY272_NAME PY272_NEWLINE PY272_NOT PY272_NOTEQUAL PY272_NUMBER
%token PY272_OR PY272_PASS PY272_PERCENT PY272_PERCENTEQUAL PY272_PLUS PY272_PLUSEQUAL PY272_PRINT PY272_RAISE PY272_RBRACE PY272_RETURN
%token PY272_RIGHTSHIFT PY272_RIGHTSHIFTEQUAL PY272_RPAR PY272_RSQB PY272_SEMI PY272_SLASH PY272_SLASHEQUAL PY272_STAR PY272_STAREQUAL
%token PY272_STRING PY272_TILDE PY272_TRY PY272_VBAREQUAL PY272_WHILE PY272_WITH PY272_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY272_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY272_AT dotted_name PY272_LPAR arglist PY272_RPAR PY272_NEWLINE
	| PY272_AT dotted_name PY272_LPAR PY272_RPAR PY272_NEWLINE
	| PY272_AT dotted_name PY272_NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	;
funcdef // Used in: decorated, compound_stmt
	: PY272_DEF PY272_NAME parameters PY272_COLON suite
	;
parameters // Used in: funcdef
	: PY272_LPAR varargslist PY272_RPAR
	| PY272_LPAR PY272_RPAR
	;
varargslist // Used in: parameters, old_lambdef, lambdef
	: star_fpdef_COMMA PY272_STAR PY272_NAME PY272_COMMA PY272_DOUBLESTAR PY272_NAME
	| star_fpdef_COMMA PY272_STAR PY272_NAME
	| star_fpdef_COMMA PY272_DOUBLESTAR PY272_NAME
	| star_fpdef_COMMA fpdef PY272_EQUAL test PY272_COMMA
	| star_fpdef_COMMA fpdef PY272_EQUAL test
	| star_fpdef_COMMA fpdef PY272_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY272_NAME
	| PY272_LPAR fplist PY272_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY272_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY272_SEMI PY272_NEWLINE
	| small_stmt star_SEMI_small_stmt PY272_NEWLINE
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
	: PY272_PLUSEQUAL
	| PY272_MINEQUAL
	| PY272_STAREQUAL
	| PY272_SLASHEQUAL
	| PY272_PERCENTEQUAL
	| PY272_AMPEREQUAL
	| PY272_VBAREQUAL
	| PY272_CIRCUMFLEXEQUAL
	| PY272_LEFTSHIFTEQUAL
	| PY272_RIGHTSHIFTEQUAL
	| PY272_DOUBLESTAREQUAL
	| PY272_DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PY272_PRINT test star_COMMA_test PY272_COMMA
	| PY272_PRINT test star_COMMA_test
	| PY272_PRINT
	| PY272_PRINT PY272_RIGHTSHIFT test plus_COMMA_test PY272_COMMA
	| PY272_PRINT PY272_RIGHTSHIFT test plus_COMMA_test
	| PY272_PRINT PY272_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY272_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY272_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY272_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY272_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY272_RETURN testlist
	| PY272_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY272_RAISE test PY272_COMMA test PY272_COMMA test
	| PY272_RAISE test PY272_COMMA test
	| PY272_RAISE test
	| PY272_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY272_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY272_FROM star_DOT dotted_name PY272_IMPORT PY272_STAR
	| PY272_FROM star_DOT dotted_name PY272_IMPORT PY272_LPAR import_as_names PY272_RPAR
	| PY272_FROM star_DOT dotted_name PY272_IMPORT import_as_names
	| PY272_FROM star_DOT PY272_DOT PY272_IMPORT PY272_STAR
	| PY272_FROM star_DOT PY272_DOT PY272_IMPORT PY272_LPAR import_as_names PY272_RPAR
	| PY272_FROM star_DOT PY272_DOT PY272_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY272_NAME PY272_AS PY272_NAME
	| PY272_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY272_AS PY272_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY272_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY272_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY272_GLOBAL PY272_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY272_EXEC expr PY272_IN test PY272_COMMA test
	| PY272_EXEC expr PY272_IN test
	| PY272_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY272_ASSERT test PY272_COMMA test
	| PY272_ASSERT test
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
	: PY272_IF test PY272_COLON suite star_ELIF PY272_ELSE PY272_COLON suite
	| PY272_IF test PY272_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY272_WHILE test PY272_COLON suite PY272_ELSE PY272_COLON suite
	| PY272_WHILE test PY272_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY272_FOR exprlist PY272_IN testlist PY272_COLON suite PY272_ELSE PY272_COLON suite
	| PY272_FOR exprlist PY272_IN testlist PY272_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY272_TRY PY272_COLON suite plus_except PY272_ELSE PY272_COLON suite PY272_FINALLY PY272_COLON suite
	| PY272_TRY PY272_COLON suite plus_except PY272_ELSE PY272_COLON suite
	| PY272_TRY PY272_COLON suite plus_except PY272_FINALLY PY272_COLON suite
	| PY272_TRY PY272_COLON suite plus_except
	| PY272_TRY PY272_COLON suite PY272_FINALLY PY272_COLON suite
	;
with_stmt // Used in: compound_stmt
	: PY272_WITH with_item star_COMMA_with_item PY272_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY272_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY272_EXCEPT test PY272_AS test
	| PY272_EXCEPT test PY272_COMMA test
	| PY272_EXCEPT test
	| PY272_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY272_NEWLINE PY272_INDENT plus_stmt PY272_DEDENT
	;
testlist_safe // Used in: list_for
	: old_test plus_COMMA_old_test PY272_COMMA
	| old_test plus_COMMA_old_test
	| old_test
	;
old_test // Used in: testlist_safe, old_lambdef, list_if, comp_if, plus_COMMA_old_test
	: or_test
	| old_lambdef
	;
old_lambdef // Used in: old_test
	: PY272_LAMBDA varargslist PY272_COLON old_test
	| PY272_LAMBDA PY272_COLON old_test
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, listmaker, testlist_comp, lambdef, subscript, sliceop, testlist, dictorsetmaker, arglist, argument, testlist1, star_fpdef_COMMA, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: or_test PY272_IF or_test PY272_ELSE test
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
	: PY272_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY272_LESS
	| PY272_GREATER
	| PY272_EQEQUAL
	| PY272_GREATEREQUAL
	| PY272_LESSEQUAL
	| PY272_GRLT
	| PY272_NOTEQUAL
	| PY272_IN
	| PY272_NOT PY272_IN
	| PY272_IS
	| PY272_IS PY272_NOT
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
	: PY272_PLUS factor
	| PY272_MINUS factor
	| PY272_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY272_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY272_LPAR yield_expr PY272_RPAR
	| PY272_LPAR testlist_comp PY272_RPAR
	| PY272_LPAR PY272_RPAR
	| PY272_LSQB listmaker PY272_RSQB
	| PY272_LSQB PY272_RSQB
	| PY272_LBRACE dictorsetmaker PY272_RBRACE
	| PY272_LBRACE PY272_RBRACE
	| PY272_BACKQUOTE testlist1 PY272_BACKQUOTE
	| PY272_NAME
	| PY272_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY272_COMMA
	| test star_COMMA_test
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_COMMA_test PY272_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY272_LAMBDA varargslist PY272_COLON test
	| PY272_LAMBDA PY272_COLON test
	;
trailer // Used in: star_trailer
	: PY272_LPAR arglist PY272_RPAR
	| PY272_LPAR PY272_RPAR
	| PY272_LSQB subscriptlist PY272_RSQB
	| PY272_DOT PY272_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY272_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY272_DOT PY272_DOT PY272_DOT
	| test
	| test PY272_COLON test sliceop
	| test PY272_COLON test
	| test PY272_COLON sliceop
	| test PY272_COLON
	| PY272_COLON test sliceop
	| PY272_COLON test
	| PY272_COLON sliceop
	| PY272_COLON
	;
sliceop // Used in: subscript
	: PY272_COLON test
	| PY272_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for, comp_for
	: expr star_COMMA_expr PY272_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, classdef, yield_expr, star_001
	: test star_COMMA_test PY272_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY272_COLON test comp_for
	| test PY272_COLON test star_test_COLON_test PY272_COMMA
	| test PY272_COLON test star_test_COLON_test
	| test comp_for
	| test star_COMMA_test PY272_COMMA
	| test star_COMMA_test
	;
classdef // Used in: decorated, compound_stmt
	: PY272_CLASS PY272_NAME PY272_LPAR testlist PY272_RPAR PY272_COLON suite
	| PY272_CLASS PY272_NAME PY272_LPAR PY272_RPAR PY272_COLON suite
	| PY272_CLASS PY272_NAME PY272_COLON suite
	;
arglist // Used in: decorator, trailer
	: star_argument_COMMA argument PY272_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY272_STAR test star_COMMA_argument PY272_COMMA PY272_DOUBLESTAR test
	| star_argument_COMMA PY272_STAR test star_COMMA_argument
	| star_argument_COMMA PY272_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA, star_COMMA_argument
	: test comp_for
	| test
	| test PY272_EQUAL test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY272_FOR exprlist PY272_IN testlist_safe list_iter
	| PY272_FOR exprlist PY272_IN testlist_safe
	;
list_if // Used in: list_iter
	: PY272_IF old_test list_iter
	| PY272_IF old_test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY272_FOR exprlist PY272_IN or_test comp_iter
	| PY272_FOR exprlist PY272_IN or_test
	;
comp_if // Used in: comp_iter
	: PY272_IF old_test comp_iter
	| PY272_IF old_test
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_001
	: PY272_YIELD testlist
	| PY272_YIELD
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY272_EQUAL test PY272_COMMA
	| star_fpdef_COMMA fpdef PY272_COMMA
	| %empty
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY272_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY272_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY272_SEMI small_stmt
	| %empty
	;
star_001 // Used in: expr_stmt, star_001
	: star_001 PY272_EQUAL yield_expr
	| star_001 PY272_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist_comp, testlist, dictorsetmaker, testlist1, star_COMMA_test
	: star_COMMA_test PY272_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, plus_COMMA_test
	: plus_COMMA_test PY272_COMMA test
	| PY272_COMMA test
	;
star_DOT // Used in: import_from, star_DOT
	: star_DOT PY272_DOT
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY272_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY272_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY272_DOT PY272_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY272_COMMA PY272_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY272_ELIF test PY272_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY272_COLON suite
	| except_clause PY272_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY272_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
plus_COMMA_old_test // Used in: testlist_safe, plus_COMMA_old_test
	: plus_COMMA_old_test PY272_COMMA old_test
	| PY272_COMMA old_test
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY272_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY272_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY272_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY272_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY272_AMPERSAND shift_expr
	| %empty
	;
star_002 // Used in: shift_expr, star_002
	: star_002 PY272_LEFTSHIFT arith_expr
	| star_002 PY272_RIGHTSHIFT arith_expr
	| %empty
	;
star_003 // Used in: arith_expr, star_003
	: star_003 PY272_PLUS term
	| star_003 PY272_MINUS term
	| %empty
	;
star_004 // Used in: term, star_004
	: star_004 PY272_STAR factor
	| star_004 PY272_SLASH factor
	| star_004 PY272_PERCENT factor
	| star_004 PY272_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY272_STRING
	| PY272_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY272_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY272_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictorsetmaker, star_test_COLON_test
	: star_test_COLON_test PY272_COMMA test PY272_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY272_COMMA
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY272_COMMA argument
	| %empty
	;

%%

void py272error(const char* msg)
{
}
