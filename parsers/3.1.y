%define api.push-pull push
%define api.pure full
%define api.prefix {py31}

%code top {
  #include <stdio.h>
  #include "3.1.tab.h"
}
%code {
void py31error(const char* msg);
}

// 86 tokens, in alphabetical order:
%token PY31_AMPEREQUAL PY31_AMPERSAND PY31_AND PY31_ARROW PY31_AS PY31_ASSERT PY31_AT PY31_BAR PY31_BREAK PY31_CIRCUMFLEX
%token PY31_CIRCUMFLEXEQUAL PY31_CLASS PY31_COLON PY31_COMMA PY31_CONTINUE PY31_DEDENT PY31_DEF PY31_DEL PY31_DOT PY31_DOUBLESLASH
%token PY31_DOUBLESLASHEQUAL PY31_DOUBLESTAR PY31_DOUBLESTAREQUAL PY31_ELIF PY31_ELSE PY31_ENDMARKER PY31_EQEQUAL
%token PY31_EQUAL PY31_EXCEPT PY31_FALSE PY31_FINALLY PY31_FOR PY31_FROM PY31_GLOBAL PY31_GREATER PY31_GREATEREQUAL PY31_GRLT
%token PY31_IF PY31_IMPORT PY31_IN PY31_INDENT PY31_IS PY31_LAMBDA PY31_LBRACE PY31_LEFTSHIFT PY31_LEFTSHIFTEQUAL PY31_LESS
%token PY31_LESSEQUAL PY31_LPAR PY31_LSQB PY31_MINEQUAL PY31_MINUS PY31_NAME PY31_NEWLINE PY31_NONE PY31_NONLOCAL PY31_NOT
%token PY31_NOTEQUAL PY31_NUMBER PY31_OR PY31_PASS PY31_PERCENT PY31_PERCENTEQUAL PY31_PLUS PY31_PLUSEQUAL PY31_RAISE
%token PY31_RBRACE PY31_RETURN PY31_RIGHTSHIFT PY31_RIGHTSHIFTEQUAL PY31_RPAR PY31_RSQB PY31_SEMI PY31_SLASH PY31_SLASHEQUAL
%token PY31_STAR PY31_STAREQUAL PY31_STRING PY31_THREE_DOTS PY31_TILDE PY31_TRUE PY31_TRY PY31_VBAREQUAL PY31_WHILE PY31_WITH
%token PY31_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY31_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY31_AT dotted_name PY31_LPAR arglist PY31_RPAR PY31_NEWLINE
	| PY31_AT dotted_name PY31_LPAR PY31_RPAR PY31_NEWLINE
	| PY31_AT dotted_name PY31_NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	;
funcdef // Used in: decorated, compound_stmt
	: PY31_DEF PY31_NAME parameters PY31_ARROW test PY31_COLON suite
	| PY31_DEF PY31_NAME parameters PY31_COLON suite
	;
parameters // Used in: funcdef
	: PY31_LPAR typedargslist PY31_RPAR
	| PY31_LPAR PY31_RPAR
	;
typedargslist // Used in: parameters
	: star_001 PY31_STAR tfpdef star_002 PY31_COMMA PY31_DOUBLESTAR tfpdef
	| star_001 PY31_STAR tfpdef star_002
	| star_001 PY31_STAR star_002 PY31_COMMA PY31_DOUBLESTAR tfpdef
	| star_001 PY31_STAR star_002
	| star_001 PY31_DOUBLESTAR tfpdef
	| star_001 tfpdef PY31_EQUAL test PY31_COMMA
	| star_001 tfpdef PY31_EQUAL test
	| star_001 tfpdef PY31_COMMA
	| star_001 tfpdef
	;
tfpdef // Used in: typedargslist, star_001, star_002
	: PY31_NAME PY31_COLON test
	| PY31_NAME
	;
varargslist // Used in: lambdef, lambdef_nocond
	: star_003 PY31_STAR vfpdef star_004 PY31_COMMA PY31_DOUBLESTAR vfpdef
	| star_003 PY31_STAR vfpdef star_004
	| star_003 PY31_STAR star_004 PY31_COMMA PY31_DOUBLESTAR vfpdef
	| star_003 PY31_STAR star_004
	| star_003 PY31_DOUBLESTAR vfpdef
	| star_003 vfpdef PY31_EQUAL test PY31_COMMA
	| star_003 vfpdef PY31_EQUAL test
	| star_003 vfpdef PY31_COMMA
	| star_003 vfpdef
	;
vfpdef // Used in: varargslist, star_003, star_004
	: PY31_NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY31_SEMI PY31_NEWLINE
	| small_stmt star_SEMI_small_stmt PY31_NEWLINE
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
	| testlist_star_expr star_005
	;
augassign // Used in: expr_stmt
	: PY31_PLUSEQUAL
	| PY31_MINEQUAL
	| PY31_STAREQUAL
	| PY31_SLASHEQUAL
	| PY31_PERCENTEQUAL
	| PY31_AMPEREQUAL
	| PY31_VBAREQUAL
	| PY31_CIRCUMFLEXEQUAL
	| PY31_LEFTSHIFTEQUAL
	| PY31_RIGHTSHIFTEQUAL
	| PY31_DOUBLESTAREQUAL
	| PY31_DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: PY31_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY31_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY31_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY31_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY31_RETURN testlist
	| PY31_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY31_RAISE test PY31_FROM test
	| PY31_RAISE test
	| PY31_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY31_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY31_FROM star_DOT_THREE_DOTS dotted_name PY31_IMPORT PY31_STAR
	| PY31_FROM star_DOT_THREE_DOTS dotted_name PY31_IMPORT PY31_LPAR import_as_names PY31_RPAR
	| PY31_FROM star_DOT_THREE_DOTS dotted_name PY31_IMPORT import_as_names
	| PY31_FROM star_DOT_THREE_DOTS PY31_DOT PY31_IMPORT PY31_STAR
	| PY31_FROM star_DOT_THREE_DOTS PY31_DOT PY31_IMPORT PY31_LPAR import_as_names PY31_RPAR
	| PY31_FROM star_DOT_THREE_DOTS PY31_DOT PY31_IMPORT import_as_names
	| PY31_FROM star_DOT_THREE_DOTS PY31_THREE_DOTS PY31_IMPORT PY31_STAR
	| PY31_FROM star_DOT_THREE_DOTS PY31_THREE_DOTS PY31_IMPORT PY31_LPAR import_as_names PY31_RPAR
	| PY31_FROM star_DOT_THREE_DOTS PY31_THREE_DOTS PY31_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY31_NAME PY31_AS PY31_NAME
	| PY31_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY31_AS PY31_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY31_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY31_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY31_GLOBAL PY31_NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: PY31_NONLOCAL PY31_NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: PY31_ASSERT test PY31_COMMA test
	| PY31_ASSERT test
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
	: PY31_IF test PY31_COLON suite star_ELIF PY31_ELSE PY31_COLON suite
	| PY31_IF test PY31_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY31_WHILE test PY31_COLON suite PY31_ELSE PY31_COLON suite
	| PY31_WHILE test PY31_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY31_FOR exprlist PY31_IN testlist PY31_COLON suite PY31_ELSE PY31_COLON suite
	| PY31_FOR exprlist PY31_IN testlist PY31_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY31_TRY PY31_COLON suite plus_except PY31_ELSE PY31_COLON suite PY31_FINALLY PY31_COLON suite
	| PY31_TRY PY31_COLON suite plus_except PY31_ELSE PY31_COLON suite
	| PY31_TRY PY31_COLON suite plus_except PY31_FINALLY PY31_COLON suite
	| PY31_TRY PY31_COLON suite plus_except
	| PY31_TRY PY31_COLON suite PY31_FINALLY PY31_COLON suite
	;
with_stmt // Used in: compound_stmt
	: PY31_WITH with_item star_COMMA_with_item PY31_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY31_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY31_EXCEPT test PY31_AS PY31_NAME
	| PY31_EXCEPT test
	| PY31_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY31_NEWLINE PY31_INDENT plus_stmt PY31_DEDENT
	;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, raise_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, lambdef, testlist_comp, subscript, sliceop, testlist, dictorsetmaker, arglist, argument, testlist_star_expr, star_001, star_002, star_003, star_004, star_ELIF, star_009, star_COMMA_test, star_test_COLON_test
	: or_test PY31_IF or_test PY31_ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: PY31_LAMBDA varargslist PY31_COLON test
	| PY31_LAMBDA PY31_COLON test
	;
lambdef_nocond // Used in: test_nocond
	: PY31_LAMBDA varargslist PY31_COLON test_nocond
	| PY31_LAMBDA PY31_COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY31_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY31_LESS
	| PY31_GREATER
	| PY31_EQEQUAL
	| PY31_GREATEREQUAL
	| PY31_LESSEQUAL
	| PY31_GRLT
	| PY31_NOTEQUAL
	| PY31_IN
	| PY31_NOT PY31_IN
	| PY31_IS
	| PY31_IS PY31_NOT
	;
star_expr // Used in: testlist_comp, exprlist, testlist_star_expr, star_009, star_010
	: PY31_STAR expr
	;
expr // Used in: with_item, comparison, star_expr, exprlist, star_comp_op_expr, star_010
	: xor_expr star_BAR_xor_expr
	;
xor_expr // Used in: expr, star_BAR_xor_expr
	: and_expr star_CIRCUMFLEX_and_expr
	;
and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: shift_expr star_AMPERSAND_shift_expr
	;
shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: arith_expr star_006
	;
arith_expr // Used in: shift_expr, star_006
	: term star_007
	;
term // Used in: arith_expr, star_007
	: factor star_008
	;
factor // Used in: term, factor, power, star_008
	: PY31_PLUS factor
	| PY31_MINUS factor
	| PY31_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY31_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY31_LPAR yield_expr PY31_RPAR
	| PY31_LPAR testlist_comp PY31_RPAR
	| PY31_LPAR PY31_RPAR
	| PY31_LSQB testlist_comp PY31_RSQB
	| PY31_LSQB PY31_RSQB
	| PY31_LBRACE dictorsetmaker PY31_RBRACE
	| PY31_LBRACE PY31_RBRACE
	| PY31_NAME
	| PY31_NUMBER
	| plus_STRING
	| PY31_THREE_DOTS
	| PY31_NONE
	| PY31_TRUE
	| PY31_FALSE
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_009 PY31_COMMA
	| test star_009
	| star_expr comp_for
	| star_expr star_009 PY31_COMMA
	| star_expr star_009
	;
trailer // Used in: star_trailer
	: PY31_LPAR arglist PY31_RPAR
	| PY31_LPAR PY31_RPAR
	| PY31_LSQB subscriptlist PY31_RSQB
	| PY31_DOT PY31_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY31_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test PY31_COLON test sliceop
	| test PY31_COLON test
	| test PY31_COLON sliceop
	| test PY31_COLON
	| PY31_COLON test sliceop
	| PY31_COLON test
	| PY31_COLON sliceop
	| PY31_COLON
	;
sliceop // Used in: subscript
	: PY31_COLON test
	| PY31_COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_010 PY31_COMMA
	| expr star_010
	| star_expr star_010 PY31_COMMA
	| star_expr star_010
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_expr
	: test star_COMMA_test PY31_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY31_COLON test comp_for
	| test PY31_COLON test star_test_COLON_test PY31_COMMA
	| test PY31_COLON test star_test_COLON_test
	| test comp_for
	| test star_COMMA_test PY31_COMMA
	| test star_COMMA_test
	;
classdef // Used in: decorated, compound_stmt
	: PY31_CLASS PY31_NAME PY31_LPAR arglist PY31_RPAR PY31_COLON suite
	| PY31_CLASS PY31_NAME PY31_LPAR PY31_RPAR PY31_COLON suite
	| PY31_CLASS PY31_NAME PY31_COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: star_argument_COMMA argument PY31_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY31_STAR test star_COMMA_argument PY31_COMMA PY31_DOUBLESTAR test
	| star_argument_COMMA PY31_STAR test star_COMMA_argument
	| star_argument_COMMA PY31_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA, star_COMMA_argument
	: test comp_for
	| test
	| test PY31_EQUAL test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY31_FOR exprlist PY31_IN or_test comp_iter
	| PY31_FOR exprlist PY31_IN or_test
	;
comp_if // Used in: comp_iter
	: PY31_IF test_nocond comp_iter
	| PY31_IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_005
	: PY31_YIELD testlist
	| PY31_YIELD
	;
testlist_star_expr // Used in: expr_stmt, star_005
	: test star_009 PY31_COMMA
	| test star_009
	| star_expr star_009 PY31_COMMA
	| star_expr star_009
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY31_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 tfpdef PY31_EQUAL test PY31_COMMA
	| star_001 tfpdef PY31_COMMA
	| %empty
	;
star_002 // Used in: typedargslist, star_002
	: star_002 PY31_COMMA tfpdef PY31_EQUAL test
	| star_002 PY31_COMMA tfpdef
	| %empty
	;
star_003 // Used in: varargslist, star_003
	: star_003 vfpdef PY31_EQUAL test PY31_COMMA
	| star_003 vfpdef PY31_COMMA
	| %empty
	;
star_004 // Used in: varargslist, star_004
	: star_004 PY31_COMMA vfpdef PY31_EQUAL test
	| star_004 PY31_COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY31_SEMI small_stmt
	| %empty
	;
star_005 // Used in: expr_stmt, star_005
	: star_005 PY31_EQUAL yield_expr
	| star_005 PY31_EQUAL testlist_star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY31_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY31_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY31_DOT PY31_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY31_COMMA PY31_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY31_ELIF test PY31_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY31_COLON suite
	| except_clause PY31_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY31_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY31_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY31_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY31_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY31_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY31_AMPERSAND shift_expr
	| %empty
	;
star_006 // Used in: shift_expr, star_006
	: star_006 PY31_LEFTSHIFT arith_expr
	| star_006 PY31_RIGHTSHIFT arith_expr
	| %empty
	;
star_007 // Used in: arith_expr, star_007
	: star_007 PY31_PLUS term
	| star_007 PY31_MINUS term
	| %empty
	;
star_008 // Used in: term, star_008
	: star_008 PY31_STAR factor
	| star_008 PY31_SLASH factor
	| star_008 PY31_PERCENT factor
	| star_008 PY31_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY31_STRING
	| PY31_STRING
	;
star_009 // Used in: testlist_comp, testlist_star_expr, star_009
	: star_009 PY31_COMMA test
	| star_009 PY31_COMMA star_expr
	| %empty
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY31_COMMA subscript
	| %empty
	;
star_010 // Used in: exprlist, star_010
	: star_010 PY31_COMMA expr
	| star_010 PY31_COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, dictorsetmaker, star_COMMA_test
	: star_COMMA_test PY31_COMMA test
	| %empty
	;
star_test_COLON_test // Used in: dictorsetmaker, star_test_COLON_test
	: star_test_COLON_test PY31_COMMA test PY31_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY31_COMMA
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY31_COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS PY31_DOT
	| star_DOT_THREE_DOTS PY31_THREE_DOTS
	| %empty
	;

%%

void py31error(const char* msg)
{
}
