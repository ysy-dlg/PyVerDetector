%define api.push-pull push
%define api.pure full
%define api.prefix {py30}

%code top {
  #include <stdio.h>
  #include "3.0.tab.h"
}
%code {
void py30error(const char* msg);
}


// 85 tokens, in alphabetical order:
%token PY30_AMPEREQUAL PY30_AMPERSAND PY30_AND PY30_ARROW PY30_AS PY30_ASSERT PY30_AT PY30_BAR PY30_BREAK PY30_CIRCUMFLEX
%token PY30_CIRCUMFLEXEQUAL PY30_CLASS PY30_COLON PY30_COMMA PY30_CONTINUE PY30_DEDENT PY30_DEF PY30_DEL PY30_DOT PY30_DOUBLESLASH
%token PY30_DOUBLESLASHEQUAL PY30_DOUBLESTAR PY30_DOUBLESTAREQUAL PY30_ELIF PY30_ELSE PY30_ENDMARKER PY30_EQEQUAL
%token PY30_EQUAL PY30_EXCEPT PY30_FALSE PY30_FINALLY PY30_FOR PY30_FROM PY30_GLOBAL PY30_GREATER PY30_GREATEREQUAL PY30_IF
%token PY30_IMPORT PY30_IN PY30_INDENT PY30_IS PY30_LAMBDA PY30_LBRACE PY30_LEFTSHIFT PY30_LEFTSHIFTEQUAL PY30_LESS PY30_LESSEQUAL
%token PY30_LPAR PY30_LSQB PY30_MINEQUAL PY30_MINUS PY30_NAME PY30_NEWLINE PY30_NONE PY30_NONLOCAL PY30_NOT PY30_NOTEQUAL
%token PY30_NUMBER PY30_OR PY30_PASS PY30_PERCENT PY30_PERCENTEQUAL PY30_PLUS PY30_PLUSEQUAL PY30_RAISE PY30_RBRACE PY30_RETURN
%token PY30_RIGHTSHIFT PY30_RIGHTSHIFTEQUAL PY30_RPAR PY30_RSQB PY30_SEMI PY30_SLASH PY30_SLASHEQUAL PY30_STAR PY30_STAREQUAL
%token PY30_STRING PY30_THREE_DOTS PY30_TILDE PY30_TRUE PY30_TRY PY30_VBAREQUAL PY30_WHILE PY30_WITH PY30_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY30_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY30_AT dotted_name PY30_LPAR arglist PY30_RPAR PY30_NEWLINE
	| PY30_AT dotted_name PY30_LPAR PY30_RPAR PY30_NEWLINE
	| PY30_AT dotted_name PY30_NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	;
funcdef // Used in: decorated, compound_stmt
	: PY30_DEF PY30_NAME parameters PY30_ARROW test PY30_COLON suite
	| PY30_DEF PY30_NAME parameters PY30_COLON suite
	;
parameters // Used in: funcdef
	: PY30_LPAR typedargslist PY30_RPAR
	| PY30_LPAR PY30_RPAR
	;
typedargslist // Used in: parameters
	: star_001 PY30_STAR tfpdef star_002 PY30_COMMA PY30_DOUBLESTAR tfpdef
	| star_001 PY30_STAR tfpdef star_002
	| star_001 PY30_STAR star_002 PY30_COMMA PY30_DOUBLESTAR tfpdef
	| star_001 PY30_STAR star_002
	| star_001 PY30_DOUBLESTAR tfpdef
	| star_001 tfpdef PY30_EQUAL test PY30_COMMA
	| star_001 tfpdef PY30_EQUAL test
	| star_001 tfpdef PY30_COMMA
	| star_001 tfpdef
	;
tfpdef // Used in: typedargslist, star_001, star_002
	: PY30_NAME PY30_COLON test
	| PY30_NAME
	;
varargslist // Used in: lambdef, lambdef_nocond
	: star_003 PY30_STAR vfpdef star_004 PY30_COMMA PY30_DOUBLESTAR vfpdef
	| star_003 PY30_STAR vfpdef star_004
	| star_003 PY30_STAR star_004 PY30_COMMA PY30_DOUBLESTAR vfpdef
	| star_003 PY30_STAR star_004
	| star_003 PY30_DOUBLESTAR vfpdef
	| star_003 vfpdef PY30_EQUAL test PY30_COMMA
	| star_003 vfpdef PY30_EQUAL test
	| star_003 vfpdef PY30_COMMA
	| star_003 vfpdef
	;
vfpdef // Used in: varargslist, star_003, star_004
	: PY30_NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY30_SEMI PY30_NEWLINE
	| small_stmt star_SEMI_small_stmt PY30_NEWLINE
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
	: PY30_PLUSEQUAL
	| PY30_MINEQUAL
	| PY30_STAREQUAL
	| PY30_SLASHEQUAL
	| PY30_PERCENTEQUAL
	| PY30_AMPEREQUAL
	| PY30_VBAREQUAL
	| PY30_CIRCUMFLEXEQUAL
	| PY30_LEFTSHIFTEQUAL
	| PY30_RIGHTSHIFTEQUAL
	| PY30_DOUBLESTAREQUAL
	| PY30_DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: PY30_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY30_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY30_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY30_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY30_RETURN testlist
	| PY30_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY30_RAISE test PY30_FROM test
	| PY30_RAISE test
	| PY30_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY30_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY30_FROM star_DOT_THREE_DOTS dotted_name PY30_IMPORT PY30_STAR
	| PY30_FROM star_DOT_THREE_DOTS dotted_name PY30_IMPORT PY30_LPAR import_as_names PY30_RPAR
	| PY30_FROM star_DOT_THREE_DOTS dotted_name PY30_IMPORT import_as_names
	| PY30_FROM star_DOT_THREE_DOTS PY30_DOT PY30_IMPORT PY30_STAR
	| PY30_FROM star_DOT_THREE_DOTS PY30_DOT PY30_IMPORT PY30_LPAR import_as_names PY30_RPAR
	| PY30_FROM star_DOT_THREE_DOTS PY30_DOT PY30_IMPORT import_as_names
	| PY30_FROM star_DOT_THREE_DOTS PY30_THREE_DOTS PY30_IMPORT PY30_STAR
	| PY30_FROM star_DOT_THREE_DOTS PY30_THREE_DOTS PY30_IMPORT PY30_LPAR import_as_names PY30_RPAR
	| PY30_FROM star_DOT_THREE_DOTS PY30_THREE_DOTS PY30_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY30_NAME PY30_AS PY30_NAME
	| PY30_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY30_AS PY30_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY30_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY30_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY30_GLOBAL PY30_NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: PY30_NONLOCAL PY30_NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: PY30_ASSERT test PY30_COMMA test
	| PY30_ASSERT test
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
	: PY30_IF test PY30_COLON suite star_ELIF PY30_ELSE PY30_COLON suite
	| PY30_IF test PY30_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY30_WHILE test PY30_COLON suite PY30_ELSE PY30_COLON suite
	| PY30_WHILE test PY30_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY30_FOR exprlist PY30_IN testlist PY30_COLON suite PY30_ELSE PY30_COLON suite
	| PY30_FOR exprlist PY30_IN testlist PY30_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY30_TRY PY30_COLON suite plus_except PY30_ELSE PY30_COLON suite PY30_FINALLY PY30_COLON suite
	| PY30_TRY PY30_COLON suite plus_except PY30_ELSE PY30_COLON suite
	| PY30_TRY PY30_COLON suite plus_except PY30_FINALLY PY30_COLON suite
	| PY30_TRY PY30_COLON suite plus_except
	| PY30_TRY PY30_COLON suite PY30_FINALLY PY30_COLON suite
	;
with_stmt // Used in: compound_stmt
	: PY30_WITH test with_var PY30_COLON suite
	| PY30_WITH test PY30_COLON suite
	;
with_var // Used in: with_stmt
	: PY30_AS expr
	;
except_clause // Used in: plus_except
	: PY30_EXCEPT test PY30_AS PY30_NAME
	| PY30_EXCEPT test
	| PY30_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY30_NEWLINE PY30_INDENT plus_stmt PY30_DEDENT
	;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, raise_stmt, assert_stmt, if_stmt, while_stmt, with_stmt, except_clause, test, lambdef, testlist_comp, subscript, sliceop, testlist, dictorsetmaker, arglist, argument, testlist_star_expr, star_001, star_002, star_003, star_004, star_ELIF, star_009, star_COMMA_test, star_test_COLON_test
	: or_test PY30_IF or_test PY30_ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: PY30_LAMBDA varargslist PY30_COLON test
	| PY30_LAMBDA PY30_COLON test
	;
lambdef_nocond // Used in: test_nocond
	: PY30_LAMBDA varargslist PY30_COLON test_nocond
	| PY30_LAMBDA PY30_COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY30_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY30_LESS
	| PY30_GREATER
	| PY30_EQEQUAL
	| PY30_GREATEREQUAL
	| PY30_LESSEQUAL
	| PY30_NOTEQUAL
	| PY30_IN
	| PY30_NOT PY30_IN
	| PY30_IS
	| PY30_IS PY30_NOT
	;
star_expr // Used in: testlist_comp, exprlist, testlist_star_expr, star_009, star_010
	: PY30_STAR expr
	;
expr // Used in: with_var, comparison, star_expr, exprlist, star_comp_op_expr, star_010
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
	: PY30_PLUS factor
	| PY30_MINUS factor
	| PY30_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY30_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY30_LPAR yield_expr PY30_RPAR
	| PY30_LPAR testlist_comp PY30_RPAR
	| PY30_LPAR PY30_RPAR
	| PY30_LSQB testlist_comp PY30_RSQB
	| PY30_LSQB PY30_RSQB
	| PY30_LBRACE dictorsetmaker PY30_RBRACE
	| PY30_LBRACE PY30_RBRACE
	| PY30_NAME
	| PY30_NUMBER
	| plus_STRING
	| PY30_THREE_DOTS
	| PY30_NONE
	| PY30_TRUE
	| PY30_FALSE
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_009 PY30_COMMA
	| test star_009
	| star_expr comp_for
	| star_expr star_009 PY30_COMMA
	| star_expr star_009
	;
trailer // Used in: star_trailer
	: PY30_LPAR arglist PY30_RPAR
	| PY30_LPAR PY30_RPAR
	| PY30_LSQB subscriptlist PY30_RSQB
	| PY30_DOT PY30_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY30_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test PY30_COLON test sliceop
	| test PY30_COLON test
	| test PY30_COLON sliceop
	| test PY30_COLON
	| PY30_COLON test sliceop
	| PY30_COLON test
	| PY30_COLON sliceop
	| PY30_COLON
	;
sliceop // Used in: subscript
	: PY30_COLON test
	| PY30_COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_010 PY30_COMMA
	| expr star_010
	| star_expr star_010 PY30_COMMA
	| star_expr star_010
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_expr
	: test star_COMMA_test PY30_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY30_COLON test comp_for
	| test PY30_COLON test star_test_COLON_test PY30_COMMA
	| test PY30_COLON test star_test_COLON_test
	| test comp_for
	| test star_COMMA_test PY30_COMMA
	| test star_COMMA_test
	;
classdef // Used in: decorated, compound_stmt
	: PY30_CLASS PY30_NAME PY30_LPAR arglist PY30_RPAR PY30_COLON suite
	| PY30_CLASS PY30_NAME PY30_LPAR PY30_RPAR PY30_COLON suite
	| PY30_CLASS PY30_NAME PY30_COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: star_argument_COMMA argument PY30_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY30_STAR test star_COMMA_argument PY30_COMMA PY30_DOUBLESTAR test
	| star_argument_COMMA PY30_STAR test star_COMMA_argument
	| star_argument_COMMA PY30_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA, star_COMMA_argument
	: test comp_for
	| test
	| test PY30_EQUAL test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY30_FOR exprlist PY30_IN or_test comp_iter
	| PY30_FOR exprlist PY30_IN or_test
	;
comp_if // Used in: comp_iter
	: PY30_IF test_nocond comp_iter
	| PY30_IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_005
	: PY30_YIELD testlist
	| PY30_YIELD
	;
testlist_star_expr // Used in: expr_stmt, star_005
	: test star_009 PY30_COMMA
	| test star_009
	| star_expr star_009 PY30_COMMA
	| star_expr star_009
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY30_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 tfpdef PY30_EQUAL test PY30_COMMA
	| star_001 tfpdef PY30_COMMA
	| %empty
	;
star_002 // Used in: typedargslist, star_002
	: star_002 PY30_COMMA tfpdef PY30_EQUAL test
	| star_002 PY30_COMMA tfpdef
	| %empty
	;
star_003 // Used in: varargslist, star_003
	: star_003 vfpdef PY30_EQUAL test PY30_COMMA
	| star_003 vfpdef PY30_COMMA
	| %empty
	;
star_004 // Used in: varargslist, star_004
	: star_004 PY30_COMMA vfpdef PY30_EQUAL test
	| star_004 PY30_COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY30_SEMI small_stmt
	| %empty
	;
star_005 // Used in: expr_stmt, star_005
	: star_005 PY30_EQUAL yield_expr
	| star_005 PY30_EQUAL testlist_star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY30_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY30_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY30_DOT PY30_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY30_COMMA PY30_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY30_ELIF test PY30_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY30_COLON suite
	| except_clause PY30_COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY30_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY30_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY30_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY30_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY30_AMPERSAND shift_expr
	| %empty
	;
star_006 // Used in: shift_expr, star_006
	: star_006 PY30_LEFTSHIFT arith_expr
	| star_006 PY30_RIGHTSHIFT arith_expr
	| %empty
	;
star_007 // Used in: arith_expr, star_007
	: star_007 PY30_PLUS term
	| star_007 PY30_MINUS term
	| %empty
	;
star_008 // Used in: term, star_008
	: star_008 PY30_STAR factor
	| star_008 PY30_SLASH factor
	| star_008 PY30_PERCENT factor
	| star_008 PY30_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY30_STRING
	| PY30_STRING
	;
star_009 // Used in: testlist_comp, testlist_star_expr, star_009
	: star_009 PY30_COMMA test
	| star_009 PY30_COMMA star_expr
	| %empty
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY30_COMMA subscript
	| %empty
	;
star_010 // Used in: exprlist, star_010
	: star_010 PY30_COMMA expr
	| star_010 PY30_COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, dictorsetmaker, star_COMMA_test
	: star_COMMA_test PY30_COMMA test
	| %empty
	;
star_test_COLON_test // Used in: dictorsetmaker, star_test_COLON_test
	: star_test_COLON_test PY30_COMMA test PY30_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY30_COMMA
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY30_COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS PY30_DOT
	| star_DOT_THREE_DOTS PY30_THREE_DOTS
	| %empty
	;

%%

void py30error(const char* msg)
{
}
