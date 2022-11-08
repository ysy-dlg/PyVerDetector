%define api.push-pull push
%define api.pure full
%define api.prefix {py32}
%define parse.error verbose
%parse-param{TokenState* t_state}

%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "3.2.tab.h"
}
%code {
void py32error(TokenState* t_state, const char* msg);
}

// 86 tokens, in alphabetical order:
%token PY32_AMPEREQUAL PY32_AMPERSAND PY32_AND PY32_ARROW PY32_AS PY32_ASSERT PY32_AT PY32_BAR PY32_BREAK PY32_CIRCUMFLEX
%token PY32_CIRCUMFLEXEQUAL PY32_CLASS PY32_COLON PY32_COMMA PY32_CONTINUE PY32_DEDENT PY32_DEF PY32_DEL PY32_DOT PY32_DOUBLESLASH
%token PY32_DOUBLESLASHEQUAL PY32_DOUBLESTAR PY32_DOUBLESTAREQUAL PY32_ELIF PY32_ELSE PY32_ENDMARKER PY32_EQEQUAL
%token PY32_EQUAL PY32_EXCEPT PY32_FALSE PY32_FINALLY PY32_FOR PY32_FROM PY32_GLOBAL PY32_GREATER PY32_GREATEREQUAL PY32_GRLT
%token PY32_IF PY32_IMPORT PY32_IN PY32_INDENT PY32_IS PY32_LAMBDA PY32_LBRACE PY32_LEFTSHIFT PY32_LEFTSHIFTEQUAL PY32_LESS
%token PY32_LESSEQUAL PY32_LPAR PY32_LSQB PY32_MINEQUAL PY32_MINUS PY32_NAME PY32_NEWLINE PY32_NONE PY32_NONLOCAL PY32_NOT
%token PY32_NOTEQUAL PY32_NUMBER PY32_OR PY32_PASS PY32_PERCENT PY32_PERCENTEQUAL PY32_PLUS PY32_PLUSEQUAL PY32_RAISE
%token PY32_RBRACE PY32_RETURN PY32_RIGHTSHIFT PY32_RIGHTSHIFTEQUAL PY32_RPAR PY32_RSQB PY32_SEMI PY32_SLASH PY32_SLASHEQUAL
%token PY32_STAR PY32_STAREQUAL PY32_STRING PY32_THREE_DOTS PY32_TILDE PY32_TRUE PY32_TRY PY32_VBAREQUAL PY32_WHILE PY32_WITH
%token PY32_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY32_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY32_AT dotted_name PY32_LPAR arglist PY32_RPAR PY32_NEWLINE
	| PY32_AT dotted_name PY32_LPAR PY32_RPAR PY32_NEWLINE
	| PY32_AT dotted_name PY32_NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	;
funcdef // Used in: decorated, compound_stmt
	: PY32_DEF PY32_NAME parameters PY32_ARROW test PY32_COLON suite
	| PY32_DEF PY32_NAME parameters PY32_COLON suite
	;
parameters // Used in: funcdef
	: PY32_LPAR typedargslist PY32_RPAR
	| PY32_LPAR PY32_RPAR
	;
typedargslist // Used in: parameters
	: tfpdef PY32_EQUAL test star_001 PY32_COMMA PY32_STAR tfpdef star_001 PY32_COMMA PY32_DOUBLESTAR tfpdef
	| tfpdef PY32_EQUAL test star_001 PY32_COMMA PY32_STAR tfpdef star_001
	| tfpdef PY32_EQUAL test star_001 PY32_COMMA PY32_STAR star_001 PY32_COMMA PY32_DOUBLESTAR tfpdef
	| tfpdef PY32_EQUAL test star_001 PY32_COMMA PY32_STAR star_001
	| tfpdef PY32_EQUAL test star_001 PY32_COMMA PY32_DOUBLESTAR tfpdef
	| tfpdef PY32_EQUAL test star_001 PY32_COMMA
	| tfpdef PY32_EQUAL test star_001
	| tfpdef star_001 PY32_COMMA PY32_STAR tfpdef star_001 PY32_COMMA PY32_DOUBLESTAR tfpdef
	| tfpdef star_001 PY32_COMMA PY32_STAR tfpdef star_001
	| tfpdef star_001 PY32_COMMA PY32_STAR star_001 PY32_COMMA PY32_DOUBLESTAR tfpdef
	| tfpdef star_001 PY32_COMMA PY32_STAR star_001
	| tfpdef star_001 PY32_COMMA PY32_DOUBLESTAR tfpdef
	| tfpdef star_001 PY32_COMMA
	| tfpdef star_001
	| PY32_STAR tfpdef star_001 PY32_COMMA PY32_DOUBLESTAR tfpdef
	| PY32_STAR tfpdef star_001
	| PY32_STAR star_001 PY32_COMMA PY32_DOUBLESTAR tfpdef
	| PY32_STAR star_001
	| PY32_DOUBLESTAR tfpdef
	;
tfpdef // Used in: typedargslist, star_001
	: PY32_NAME PY32_COLON test
	| PY32_NAME
	;
varargslist // Used in: lambdef, lambdef_nocond
	: vfpdef PY32_EQUAL test star_002 PY32_COMMA PY32_STAR vfpdef star_002 PY32_COMMA PY32_DOUBLESTAR vfpdef
	| vfpdef PY32_EQUAL test star_002 PY32_COMMA PY32_STAR vfpdef star_002
	| vfpdef PY32_EQUAL test star_002 PY32_COMMA PY32_STAR star_002 PY32_COMMA PY32_DOUBLESTAR vfpdef
	| vfpdef PY32_EQUAL test star_002 PY32_COMMA PY32_STAR star_002
	| vfpdef PY32_EQUAL test star_002 PY32_COMMA PY32_DOUBLESTAR vfpdef
	| vfpdef PY32_EQUAL test star_002 PY32_COMMA
	| vfpdef PY32_EQUAL test star_002
	| vfpdef star_002 PY32_COMMA PY32_STAR vfpdef star_002 PY32_COMMA PY32_DOUBLESTAR vfpdef
	| vfpdef star_002 PY32_COMMA PY32_STAR vfpdef star_002
	| vfpdef star_002 PY32_COMMA PY32_STAR star_002 PY32_COMMA PY32_DOUBLESTAR vfpdef
	| vfpdef star_002 PY32_COMMA PY32_STAR star_002
	| vfpdef star_002 PY32_COMMA PY32_DOUBLESTAR vfpdef
	| vfpdef star_002 PY32_COMMA
	| vfpdef star_002
	| PY32_STAR vfpdef star_002 PY32_COMMA PY32_DOUBLESTAR vfpdef
	| PY32_STAR vfpdef star_002
	| PY32_STAR star_002 PY32_COMMA PY32_DOUBLESTAR vfpdef
	| PY32_STAR star_002
	| PY32_DOUBLESTAR vfpdef
	;
vfpdef // Used in: varargslist, star_002
	: PY32_NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY32_SEMI PY32_NEWLINE
	| small_stmt star_SEMI_small_stmt PY32_NEWLINE
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
	: test star_004 PY32_COMMA
	| test star_004
	| star_expr star_004 PY32_COMMA
	| star_expr star_004
	;
augassign // Used in: expr_stmt
	: PY32_PLUSEQUAL
	| PY32_MINEQUAL
	| PY32_STAREQUAL
	| PY32_SLASHEQUAL
	| PY32_PERCENTEQUAL
	| PY32_AMPEREQUAL
	| PY32_VBAREQUAL
	| PY32_CIRCUMFLEXEQUAL
	| PY32_LEFTSHIFTEQUAL
	| PY32_RIGHTSHIFTEQUAL
	| PY32_DOUBLESTAREQUAL
	| PY32_DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: PY32_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY32_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY32_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY32_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY32_RETURN testlist
	| PY32_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY32_RAISE test PY32_FROM test
	| PY32_RAISE test
	| PY32_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY32_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY32_FROM star_DOT_THREE_DOTS dotted_name PY32_IMPORT PY32_STAR
	| PY32_FROM star_DOT_THREE_DOTS dotted_name PY32_IMPORT PY32_LPAR import_as_names PY32_RPAR
	| PY32_FROM star_DOT_THREE_DOTS dotted_name PY32_IMPORT import_as_names
	| PY32_FROM star_DOT_THREE_DOTS PY32_DOT PY32_IMPORT PY32_STAR
	| PY32_FROM star_DOT_THREE_DOTS PY32_DOT PY32_IMPORT PY32_LPAR import_as_names PY32_RPAR
	| PY32_FROM star_DOT_THREE_DOTS PY32_DOT PY32_IMPORT import_as_names
	| PY32_FROM star_DOT_THREE_DOTS PY32_THREE_DOTS PY32_IMPORT PY32_STAR
	| PY32_FROM star_DOT_THREE_DOTS PY32_THREE_DOTS PY32_IMPORT PY32_LPAR import_as_names PY32_RPAR
	| PY32_FROM star_DOT_THREE_DOTS PY32_THREE_DOTS PY32_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY32_NAME PY32_AS PY32_NAME
	| PY32_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY32_AS PY32_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY32_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY32_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY32_GLOBAL PY32_NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: PY32_NONLOCAL PY32_NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: PY32_ASSERT test PY32_COMMA test
	| PY32_ASSERT test
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
	: PY32_IF test PY32_COLON suite star_ELIF PY32_ELSE PY32_COLON suite
	| PY32_IF test PY32_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY32_WHILE test PY32_COLON suite PY32_ELSE PY32_COLON suite
	| PY32_WHILE test PY32_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY32_FOR exprlist PY32_IN testlist PY32_COLON suite PY32_ELSE PY32_COLON suite
	| PY32_FOR exprlist PY32_IN testlist PY32_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY32_TRY PY32_COLON suite plus_except PY32_ELSE PY32_COLON suite PY32_FINALLY PY32_COLON suite
	| PY32_TRY PY32_COLON suite plus_except PY32_ELSE PY32_COLON suite
	| PY32_TRY PY32_COLON suite plus_except PY32_FINALLY PY32_COLON suite
	| PY32_TRY PY32_COLON suite plus_except
	| PY32_TRY PY32_COLON suite PY32_FINALLY PY32_COLON suite
	;
with_stmt // Used in: compound_stmt
	: PY32_WITH with_item star_COMMA_with_item PY32_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY32_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY32_EXCEPT test PY32_AS PY32_NAME
	| PY32_EXCEPT test
	| PY32_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY32_NEWLINE PY32_INDENT plus_stmt PY32_DEDENT
	;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, testlist_star_expr, raise_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, lambdef, testlist_comp, subscript, sliceop, testlist, dictorsetmaker, arglist, argument, star_001, star_002, star_004, star_ELIF, star_COMMA_test, star_test_COLON_test
	: or_test PY32_IF or_test PY32_ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: PY32_LAMBDA varargslist PY32_COLON test
	| PY32_LAMBDA PY32_COLON test
	;
lambdef_nocond // Used in: test_nocond
	: PY32_LAMBDA varargslist PY32_COLON test_nocond
	| PY32_LAMBDA PY32_COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY32_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY32_LESS
	| PY32_GREATER
	| PY32_EQEQUAL
	| PY32_GREATEREQUAL
	| PY32_LESSEQUAL
	| PY32_GRLT
	| PY32_NOTEQUAL
	| PY32_IN
	| PY32_NOT PY32_IN
	| PY32_IS
	| PY32_IS PY32_NOT
	;
star_expr // Used in: testlist_star_expr, testlist_comp, exprlist, star_004, star_008
	: PY32_STAR expr
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
	: PY32_PLUS factor
	| PY32_MINUS factor
	| PY32_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY32_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY32_LPAR yield_expr PY32_RPAR
	| PY32_LPAR testlist_comp PY32_RPAR
	| PY32_LPAR PY32_RPAR
	| PY32_LSQB testlist_comp PY32_RSQB
	| PY32_LSQB PY32_RSQB
	| PY32_LBRACE dictorsetmaker PY32_RBRACE
	| PY32_LBRACE PY32_RBRACE
	| PY32_NAME
	| PY32_NUMBER
	| plus_STRING
	| PY32_THREE_DOTS
	| PY32_NONE
	| PY32_TRUE
	| PY32_FALSE
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_004 PY32_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY32_COMMA
	| star_expr star_004
	;
trailer // Used in: star_trailer
	: PY32_LPAR arglist PY32_RPAR
	| PY32_LPAR PY32_RPAR
	| PY32_LSQB subscriptlist PY32_RSQB
	| PY32_DOT PY32_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY32_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test PY32_COLON test sliceop
	| test PY32_COLON test
	| test PY32_COLON sliceop
	| test PY32_COLON
	| PY32_COLON test sliceop
	| PY32_COLON test
	| PY32_COLON sliceop
	| PY32_COLON
	;
sliceop // Used in: subscript
	: PY32_COLON test
	| PY32_COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_008 PY32_COMMA
	| expr star_008
	| star_expr star_008 PY32_COMMA
	| star_expr star_008
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_expr
	: test star_COMMA_test PY32_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY32_COLON test comp_for
	| test PY32_COLON test star_test_COLON_test PY32_COMMA
	| test PY32_COLON test star_test_COLON_test
	| test comp_for
	| test star_COMMA_test PY32_COMMA
	| test star_COMMA_test
	;
classdef // Used in: decorated, compound_stmt
	: PY32_CLASS PY32_NAME PY32_LPAR arglist PY32_RPAR PY32_COLON suite
	| PY32_CLASS PY32_NAME PY32_LPAR PY32_RPAR PY32_COLON suite
	| PY32_CLASS PY32_NAME PY32_COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: star_argument_COMMA argument PY32_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY32_STAR test star_COMMA_argument PY32_COMMA PY32_DOUBLESTAR test
	| star_argument_COMMA PY32_STAR test star_COMMA_argument
	| star_argument_COMMA PY32_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA, star_COMMA_argument
	: test comp_for
	| test
	| test PY32_EQUAL test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY32_FOR exprlist PY32_IN or_test comp_iter
	| PY32_FOR exprlist PY32_IN or_test
	;
comp_if // Used in: comp_iter
	: PY32_IF test_nocond comp_iter
	| PY32_IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_003
	: PY32_YIELD testlist
	| PY32_YIELD
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY32_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 PY32_COMMA tfpdef PY32_EQUAL test
	| star_001 PY32_COMMA tfpdef
	| %empty
	;
star_002 // Used in: varargslist, star_002
	: star_002 PY32_COMMA vfpdef PY32_EQUAL test
	| star_002 PY32_COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY32_SEMI small_stmt
	| %empty
	;
star_003 // Used in: expr_stmt, star_003
	: star_003 PY32_EQUAL yield_expr
	| star_003 PY32_EQUAL testlist_star_expr
	| %empty
	;
star_004 // Used in: testlist_star_expr, testlist_comp, star_004
	: star_004 PY32_COMMA test
	| star_004 PY32_COMMA star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY32_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY32_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY32_DOT PY32_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY32_COMMA PY32_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY32_ELIF test PY32_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY32_COLON suite
	| except_clause PY32_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY32_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY32_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY32_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY32_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY32_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY32_AMPERSAND shift_expr
	| %empty
	;
star_005 // Used in: shift_expr, star_005
	: star_005 PY32_LEFTSHIFT arith_expr
	| star_005 PY32_RIGHTSHIFT arith_expr
	| %empty
	;
star_006 // Used in: arith_expr, star_006
	: star_006 PY32_PLUS term
	| star_006 PY32_MINUS term
	| %empty
	;
star_007 // Used in: term, star_007
	: star_007 PY32_STAR factor
	| star_007 PY32_SLASH factor
	| star_007 PY32_PERCENT factor
	| star_007 PY32_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY32_STRING
	| PY32_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY32_COMMA subscript
	| %empty
	;
star_008 // Used in: exprlist, star_008
	: star_008 PY32_COMMA expr
	| star_008 PY32_COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, dictorsetmaker, star_COMMA_test
	: star_COMMA_test PY32_COMMA test
	| %empty
	;
star_test_COLON_test // Used in: dictorsetmaker, star_test_COLON_test
	: star_test_COLON_test PY32_COMMA test PY32_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY32_COMMA
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY32_COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS PY32_DOT
	| star_DOT_THREE_DOTS PY32_THREE_DOTS
	| %empty
	;

%%

void py32error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
