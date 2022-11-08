%define api.push-pull push
%define api.pure full
%define api.prefix {py33}
%define parse.error verbose
%parse-param{TokenState* t_state}

%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "3.3.tab.h"
}
%code {
void py33error(TokenState* t_state, const char* msg);
}

// 86 tokens, in alphabetical order:
%token PY33_AMPEREQUAL PY33_AMPERSAND PY33_AND PY33_ARROW PY33_AS PY33_ASSERT PY33_AT PY33_BAR PY33_BREAK PY33_CIRCUMFLEX
%token PY33_CIRCUMFLEXEQUAL PY33_CLASS PY33_COLON PY33_COMMA PY33_CONTINUE PY33_DEDENT PY33_DEF PY33_DEL PY33_DOT PY33_DOUBLESLASH
%token PY33_DOUBLESLASHEQUAL PY33_DOUBLESTAR PY33_DOUBLESTAREQUAL PY33_ELIF PY33_ELSE PY33_ENDMARKER PY33_EQEQUAL
%token PY33_EQUAL PY33_EXCEPT PY33_FALSE PY33_FINALLY PY33_FOR PY33_FROM PY33_GLOBAL PY33_GREATER PY33_GREATEREQUAL PY33_GRLT
%token PY33_IF PY33_IMPORT PY33_IN PY33_INDENT PY33_IS PY33_LAMBDA PY33_LBRACE PY33_LEFTSHIFT PY33_LEFTSHIFTEQUAL PY33_LESS
%token PY33_LESSEQUAL PY33_LPAR PY33_LSQB PY33_MINEQUAL PY33_MINUS PY33_NAME PY33_NEWLINE PY33_NONE PY33_NONLOCAL PY33_NOT
%token PY33_NOTEQUAL PY33_NUMBER PY33_OR PY33_PASS PY33_PERCENT PY33_PERCENTEQUAL PY33_PLUS PY33_PLUSEQUAL PY33_RAISE
%token PY33_RBRACE PY33_RETURN PY33_RIGHTSHIFT PY33_RIGHTSHIFTEQUAL PY33_RPAR PY33_RSQB PY33_SEMI PY33_SLASH PY33_SLASHEQUAL
%token PY33_STAR PY33_STAREQUAL PY33_STRING PY33_THREE_DOTS PY33_TILDE PY33_TRUE PY33_TRY PY33_VBAREQUAL PY33_WHILE PY33_WITH
%token PY33_YIELD

%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY33_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY33_AT dotted_name PY33_LPAR arglist PY33_RPAR PY33_NEWLINE
	| PY33_AT dotted_name PY33_LPAR PY33_RPAR PY33_NEWLINE
	| PY33_AT dotted_name PY33_NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	;
funcdef // Used in: decorated, compound_stmt
	: PY33_DEF PY33_NAME parameters PY33_ARROW test PY33_COLON suite
	| PY33_DEF PY33_NAME parameters PY33_COLON suite
	;
parameters // Used in: funcdef
	: PY33_LPAR typedargslist PY33_RPAR
	| PY33_LPAR PY33_RPAR
	;
typedargslist // Used in: parameters
	: tfpdef PY33_EQUAL test star_001 PY33_COMMA PY33_STAR tfpdef star_001 PY33_COMMA PY33_DOUBLESTAR tfpdef
	| tfpdef PY33_EQUAL test star_001 PY33_COMMA PY33_STAR tfpdef star_001
	| tfpdef PY33_EQUAL test star_001 PY33_COMMA PY33_STAR star_001 PY33_COMMA PY33_DOUBLESTAR tfpdef
	| tfpdef PY33_EQUAL test star_001 PY33_COMMA PY33_STAR star_001
	| tfpdef PY33_EQUAL test star_001 PY33_COMMA PY33_DOUBLESTAR tfpdef
	| tfpdef PY33_EQUAL test star_001 PY33_COMMA
	| tfpdef PY33_EQUAL test star_001
	| tfpdef star_001 PY33_COMMA PY33_STAR tfpdef star_001 PY33_COMMA PY33_DOUBLESTAR tfpdef
	| tfpdef star_001 PY33_COMMA PY33_STAR tfpdef star_001
	| tfpdef star_001 PY33_COMMA PY33_STAR star_001 PY33_COMMA PY33_DOUBLESTAR tfpdef
	| tfpdef star_001 PY33_COMMA PY33_STAR star_001
	| tfpdef star_001 PY33_COMMA PY33_DOUBLESTAR tfpdef
	| tfpdef star_001 PY33_COMMA
	| tfpdef star_001
	| PY33_STAR tfpdef star_001 PY33_COMMA PY33_DOUBLESTAR tfpdef
	| PY33_STAR tfpdef star_001
	| PY33_STAR star_001 PY33_COMMA PY33_DOUBLESTAR tfpdef
	| PY33_STAR star_001
	| PY33_DOUBLESTAR tfpdef
	;
tfpdef // Used in: typedargslist, star_001
	: PY33_NAME PY33_COLON test
	| PY33_NAME
	;
varargslist // Used in: lambdef, lambdef_nocond
	: vfpdef PY33_EQUAL test star_002 PY33_COMMA PY33_STAR vfpdef star_002 PY33_COMMA PY33_DOUBLESTAR vfpdef
	| vfpdef PY33_EQUAL test star_002 PY33_COMMA PY33_STAR vfpdef star_002
	| vfpdef PY33_EQUAL test star_002 PY33_COMMA PY33_STAR star_002 PY33_COMMA PY33_DOUBLESTAR vfpdef
	| vfpdef PY33_EQUAL test star_002 PY33_COMMA PY33_STAR star_002
	| vfpdef PY33_EQUAL test star_002 PY33_COMMA PY33_DOUBLESTAR vfpdef
	| vfpdef PY33_EQUAL test star_002 PY33_COMMA
	| vfpdef PY33_EQUAL test star_002
	| vfpdef star_002 PY33_COMMA PY33_STAR vfpdef star_002 PY33_COMMA PY33_DOUBLESTAR vfpdef
	| vfpdef star_002 PY33_COMMA PY33_STAR vfpdef star_002
	| vfpdef star_002 PY33_COMMA PY33_STAR star_002 PY33_COMMA PY33_DOUBLESTAR vfpdef
	| vfpdef star_002 PY33_COMMA PY33_STAR star_002
	| vfpdef star_002 PY33_COMMA PY33_DOUBLESTAR vfpdef
	| vfpdef star_002 PY33_COMMA
	| vfpdef star_002
	| PY33_STAR vfpdef star_002 PY33_COMMA PY33_DOUBLESTAR vfpdef
	| PY33_STAR vfpdef star_002
	| PY33_STAR star_002 PY33_COMMA PY33_DOUBLESTAR vfpdef
	| PY33_STAR star_002
	| PY33_DOUBLESTAR vfpdef
	;
vfpdef // Used in: varargslist, star_002
	: PY33_NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY33_SEMI PY33_NEWLINE
	| small_stmt star_SEMI_small_stmt PY33_NEWLINE
	;
small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: expr_stmt
	| del_stmt
	| pass_stmt
	| flow_stmt
	| import_stmt
	| global_stmt
	| nonlocal_stmt
	| assert_stmt
	;
expr_stmt // Used in: small_stmt
	: testlist_star_expr augassign yield_expr
	| testlist_star_expr augassign testlist
	| testlist_star_expr star_003
	;
testlist_star_expr // Used in: expr_stmt, star_003
	: test star_004 PY33_COMMA
	| test star_004
	| star_expr star_004 PY33_COMMA
	| star_expr star_004
	;
augassign // Used in: expr_stmt
	: PY33_PLUSEQUAL
	| PY33_MINEQUAL
	| PY33_STAREQUAL
	| PY33_SLASHEQUAL
	| PY33_PERCENTEQUAL
	| PY33_AMPEREQUAL
	| PY33_VBAREQUAL
	| PY33_CIRCUMFLEXEQUAL
	| PY33_LEFTSHIFTEQUAL
	| PY33_RIGHTSHIFTEQUAL
	| PY33_DOUBLESTAREQUAL
	| PY33_DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: PY33_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY33_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY33_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY33_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY33_RETURN testlist
	| PY33_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY33_RAISE test PY33_FROM test
	| PY33_RAISE test
	| PY33_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY33_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY33_FROM star_DOT_THREE_DOTS dotted_name PY33_IMPORT PY33_STAR
	| PY33_FROM star_DOT_THREE_DOTS dotted_name PY33_IMPORT PY33_LPAR import_as_names PY33_RPAR
	| PY33_FROM star_DOT_THREE_DOTS dotted_name PY33_IMPORT import_as_names
	| PY33_FROM star_DOT_THREE_DOTS PY33_DOT PY33_IMPORT PY33_STAR
	| PY33_FROM star_DOT_THREE_DOTS PY33_DOT PY33_IMPORT PY33_LPAR import_as_names PY33_RPAR
	| PY33_FROM star_DOT_THREE_DOTS PY33_DOT PY33_IMPORT import_as_names
	| PY33_FROM star_DOT_THREE_DOTS PY33_THREE_DOTS PY33_IMPORT PY33_STAR
	| PY33_FROM star_DOT_THREE_DOTS PY33_THREE_DOTS PY33_IMPORT PY33_LPAR import_as_names PY33_RPAR
	| PY33_FROM star_DOT_THREE_DOTS PY33_THREE_DOTS PY33_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY33_NAME PY33_AS PY33_NAME
	| PY33_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY33_AS PY33_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY33_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY33_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY33_GLOBAL PY33_NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: PY33_NONLOCAL PY33_NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: PY33_ASSERT test PY33_COMMA test
	| PY33_ASSERT test
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
	: PY33_IF test PY33_COLON suite star_ELIF PY33_ELSE PY33_COLON suite
	| PY33_IF test PY33_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY33_WHILE test PY33_COLON suite PY33_ELSE PY33_COLON suite
	| PY33_WHILE test PY33_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY33_FOR exprlist PY33_IN testlist PY33_COLON suite PY33_ELSE PY33_COLON suite
	| PY33_FOR exprlist PY33_IN testlist PY33_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY33_TRY PY33_COLON suite plus_except PY33_ELSE PY33_COLON suite PY33_FINALLY PY33_COLON suite
	| PY33_TRY PY33_COLON suite plus_except PY33_ELSE PY33_COLON suite
	| PY33_TRY PY33_COLON suite plus_except PY33_FINALLY PY33_COLON suite
	| PY33_TRY PY33_COLON suite plus_except
	| PY33_TRY PY33_COLON suite PY33_FINALLY PY33_COLON suite
	;
with_stmt // Used in: compound_stmt
	: PY33_WITH with_item star_COMMA_with_item PY33_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY33_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY33_EXCEPT test PY33_AS PY33_NAME
	| PY33_EXCEPT test
	| PY33_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY33_NEWLINE PY33_INDENT plus_stmt PY33_DEDENT
	;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, testlist_star_expr, raise_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, lambdef, testlist_comp, subscript, sliceop, testlist, dictorsetmaker, arglist, argument, yield_arg, star_001, star_002, star_004, star_ELIF, star_COMMA_test, star_test_COLON_test
	: or_test PY33_IF or_test PY33_ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: PY33_LAMBDA varargslist PY33_COLON test
	| PY33_LAMBDA PY33_COLON test
	;
lambdef_nocond // Used in: test_nocond
	: PY33_LAMBDA varargslist PY33_COLON test_nocond
	| PY33_LAMBDA PY33_COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY33_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY33_LESS
	| PY33_GREATER
	| PY33_EQEQUAL
	| PY33_GREATEREQUAL
	| PY33_LESSEQUAL
	| PY33_GRLT
	| PY33_NOTEQUAL
	| PY33_IN
	| PY33_NOT PY33_IN
	| PY33_IS
	| PY33_IS PY33_NOT
	;
star_expr // Used in: testlist_star_expr, testlist_comp, exprlist, star_004, star_008
	: PY33_STAR expr
	;
expr // Used in: with_item, comparison, star_expr, exprlist, star_comp_op_expr, star_008
	: xor_expr star_BAR_xor_expr
	;
xor_expr // Used in: expr, star_BAR_xor_expr
	: and_expr star_CIRCUMFLEX_and_expr
	;
and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: shift_expr star_AMPERSAND_shift_expr
	;
shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: arith_expr star_005
	;
arith_expr // Used in: shift_expr, star_005
	: term star_006
	;
term // Used in: arith_expr, star_006
	: factor star_007
	;
factor // Used in: term, factor, power, star_007
	: PY33_PLUS factor
	| PY33_MINUS factor
	| PY33_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY33_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY33_LPAR yield_expr PY33_RPAR
	| PY33_LPAR testlist_comp PY33_RPAR
	| PY33_LPAR PY33_RPAR
	| PY33_LSQB testlist_comp PY33_RSQB
	| PY33_LSQB PY33_RSQB
	| PY33_LBRACE dictorsetmaker PY33_RBRACE
	| PY33_LBRACE PY33_RBRACE
	| PY33_NAME
	| PY33_NUMBER
	| plus_STRING
	| PY33_THREE_DOTS
	| PY33_NONE
	| PY33_TRUE
	| PY33_FALSE
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_004 PY33_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY33_COMMA
	| star_expr star_004
	;
trailer // Used in: star_trailer
	: PY33_LPAR arglist PY33_RPAR
	| PY33_LPAR PY33_RPAR
	| PY33_LSQB subscriptlist PY33_RSQB
	| PY33_DOT PY33_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY33_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test PY33_COLON test sliceop
	| test PY33_COLON test
	| test PY33_COLON sliceop
	| test PY33_COLON
	| PY33_COLON test sliceop
	| PY33_COLON test
	| PY33_COLON sliceop
	| PY33_COLON
	;
sliceop // Used in: subscript
	: PY33_COLON test
	| PY33_COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_008 PY33_COMMA
	| expr star_008
	| star_expr star_008 PY33_COMMA
	| star_expr star_008
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_arg
	: test star_COMMA_test PY33_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY33_COLON test comp_for
	| test PY33_COLON test star_test_COLON_test PY33_COMMA
	| test PY33_COLON test star_test_COLON_test
	| test comp_for
	| test star_COMMA_test PY33_COMMA
	| test star_COMMA_test
	;
classdef // Used in: decorated, compound_stmt
	: PY33_CLASS PY33_NAME PY33_LPAR arglist PY33_RPAR PY33_COLON suite
	| PY33_CLASS PY33_NAME PY33_LPAR PY33_RPAR PY33_COLON suite
	| PY33_CLASS PY33_NAME PY33_COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: star_argument_COMMA argument PY33_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY33_STAR test star_COMMA_argument PY33_COMMA PY33_DOUBLESTAR test
	| star_argument_COMMA PY33_STAR test star_COMMA_argument
	| star_argument_COMMA PY33_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA, star_COMMA_argument
	: test comp_for
	| test
	| test PY33_EQUAL test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY33_FOR exprlist PY33_IN or_test comp_iter
	| PY33_FOR exprlist PY33_IN or_test
	;
comp_if // Used in: comp_iter
	: PY33_IF test_nocond comp_iter
	| PY33_IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_003
	: PY33_YIELD yield_arg
	| PY33_YIELD
	;
yield_arg // Used in: yield_expr
	: PY33_FROM test
	| testlist
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY33_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 PY33_COMMA tfpdef PY33_EQUAL test
	| star_001 PY33_COMMA tfpdef
	| %empty
	;
star_002 // Used in: varargslist, star_002
	: star_002 PY33_COMMA vfpdef PY33_EQUAL test
	| star_002 PY33_COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY33_SEMI small_stmt
	| %empty
	;
star_003 // Used in: expr_stmt, star_003
	: star_003 PY33_EQUAL yield_expr
	| star_003 PY33_EQUAL testlist_star_expr
	| %empty
	;
star_004 // Used in: testlist_star_expr, testlist_comp, star_004
	: star_004 PY33_COMMA test
	| star_004 PY33_COMMA star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY33_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY33_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY33_DOT PY33_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY33_COMMA PY33_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY33_ELIF test PY33_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY33_COLON suite
	| except_clause PY33_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY33_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY33_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY33_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY33_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY33_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY33_AMPERSAND shift_expr
	| %empty
	;
star_005 // Used in: shift_expr, star_005
	: star_005 PY33_LEFTSHIFT arith_expr
	| star_005 PY33_RIGHTSHIFT arith_expr
	| %empty
	;
star_006 // Used in: arith_expr, star_006
	: star_006 PY33_PLUS term
	| star_006 PY33_MINUS term
	| %empty
	;
star_007 // Used in: term, star_007
	: star_007 PY33_STAR factor
	| star_007 PY33_SLASH factor
	| star_007 PY33_PERCENT factor
	| star_007 PY33_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY33_STRING
	| PY33_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY33_COMMA subscript
	| %empty
	;
star_008 // Used in: exprlist, star_008
	: star_008 PY33_COMMA expr
	| star_008 PY33_COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, dictorsetmaker, star_COMMA_test
	: star_COMMA_test PY33_COMMA test
	| %empty
	;
star_test_COLON_test // Used in: dictorsetmaker, star_test_COLON_test
	: star_test_COLON_test PY33_COMMA test PY33_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY33_COMMA
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY33_COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS PY33_DOT
	| star_DOT_THREE_DOTS PY33_THREE_DOTS
	| %empty
	;

%%

void py33error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
