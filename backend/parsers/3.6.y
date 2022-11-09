%define api.push-pull push
%define api.pure full
%define api.prefix {py36}
%define parse.error verbose
%parse-param{TokenState* t_state}
 
%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "3.6.tab.h"
}
%code {
void py36error(TokenState* t_state, const char* msg);
}
// 89 tokens, in alphabetical order:
%token PY36_AMPEREQUAL PY36_AMPERSAND PY36_AND PY36_ARROW PY36_AS PY36_ASSERT PY36_ASYNC PY36_AT PY36_ATEQ PY36_AWAIT PY36_BAR
%token PY36_BREAK PY36_CIRCUMFLEX PY36_CIRCUMFLEXEQUAL PY36_CLASS PY36_COLON PY36_COMMA PY36_CONTINUE PY36_DEDENT
%token PY36_DEF PY36_DEL PY36_DOT PY36_DOUBLESLASH PY36_DOUBLESLASHEQUAL PY36_DOUBLESTAR PY36_DOUBLESTAREQUAL
%token PY36_ELIF PY36_ELSE PY36_ENDMARKER PY36_EQEQUAL PY36_EQUAL PY36_EXCEPT PY36_FALSE PY36_FINALLY PY36_FOR PY36_FROM PY36_GLOBAL
%token PY36_GREATER PY36_GREATEREQUAL PY36_GRLT PY36_IF PY36_IMPORT PY36_IN PY36_INDENT PY36_IS PY36_LAMBDA PY36_LBRACE PY36_LEFTSHIFT
%token PY36_LEFTSHIFTEQUAL PY36_LESS PY36_LESSEQUAL PY36_LPAR PY36_LSQB PY36_MINEQUAL PY36_MINUS PY36_NAME PY36_NEWLINE
%token PY36_NONE PY36_NONLOCAL PY36_NOT PY36_NOTEQUAL PY36_NUMBER PY36_OR PY36_PASS PY36_PERCENT PY36_PERCENTEQUAL PY36_PLUS
%token PY36_PLUSEQUAL PY36_RAISE PY36_RBRACE PY36_RETURN PY36_RIGHTSHIFT PY36_RIGHTSHIFTEQUAL PY36_RPAR PY36_RSQB
%token PY36_SEMI PY36_SLASH PY36_SLASHEQUAL PY36_STAR PY36_STAREQUAL PY36_STRING PY36_THREE_DOTS PY36_TILDE PY36_TRUE
%token PY36_TRY PY36_VBAREQUAL PY36_WHILE PY36_WITH PY36_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY36_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY36_AT dotted_name PY36_LPAR arglist PY36_RPAR PY36_NEWLINE
	| PY36_AT dotted_name PY36_LPAR PY36_RPAR PY36_NEWLINE
	| PY36_AT dotted_name PY36_NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	| decorators async_funcdef
	;
async_funcdef // Used in: decorated
	: PY36_ASYNC funcdef
	;
funcdef // Used in: decorated, async_funcdef, compound_stmt, async_stmt
	: PY36_DEF PY36_NAME parameters PY36_ARROW test PY36_COLON suite
	| PY36_DEF PY36_NAME parameters PY36_COLON suite
	;
parameters // Used in: funcdef
	: PY36_LPAR typedargslist PY36_RPAR
	| PY36_LPAR PY36_RPAR
	;
typedargslist // Used in: parameters
	: tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_STAR tfpdef star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef PY36_COMMA
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_STAR tfpdef star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_STAR tfpdef star_001 PY36_COMMA
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_STAR tfpdef star_001
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_STAR star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef PY36_COMMA
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_STAR star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_STAR star_001 PY36_COMMA
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_STAR star_001
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef PY36_COMMA
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef
	| tfpdef PY36_EQUAL test star_001 PY36_COMMA
	| tfpdef PY36_EQUAL test star_001
	| tfpdef star_001 PY36_COMMA PY36_STAR tfpdef star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef PY36_COMMA
	| tfpdef star_001 PY36_COMMA PY36_STAR tfpdef star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef
	| tfpdef star_001 PY36_COMMA PY36_STAR tfpdef star_001 PY36_COMMA
	| tfpdef star_001 PY36_COMMA PY36_STAR tfpdef star_001
	| tfpdef star_001 PY36_COMMA PY36_STAR star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef PY36_COMMA
	| tfpdef star_001 PY36_COMMA PY36_STAR star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef
	| tfpdef star_001 PY36_COMMA PY36_STAR star_001 PY36_COMMA
	| tfpdef star_001 PY36_COMMA PY36_STAR star_001
	| tfpdef star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef PY36_COMMA
	| tfpdef star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef
	| tfpdef star_001 PY36_COMMA
	| tfpdef star_001
	| PY36_STAR tfpdef star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef PY36_COMMA
	| PY36_STAR tfpdef star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef
	| PY36_STAR tfpdef star_001 PY36_COMMA
	| PY36_STAR tfpdef star_001
	| PY36_STAR star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef PY36_COMMA
	| PY36_STAR star_001 PY36_COMMA PY36_DOUBLESTAR tfpdef
	| PY36_STAR star_001 PY36_COMMA
	| PY36_STAR star_001
	| PY36_DOUBLESTAR tfpdef PY36_COMMA
	| PY36_DOUBLESTAR tfpdef
	;
tfpdef // Used in: typedargslist, star_001
	: PY36_NAME PY36_COLON test
	| PY36_NAME
	;
varargslist // Used in: lambdef, lambdef_nocond
	: vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_STAR vfpdef star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef PY36_COMMA
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_STAR vfpdef star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_STAR vfpdef star_002 PY36_COMMA
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_STAR vfpdef star_002
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_STAR star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef PY36_COMMA
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_STAR star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_STAR star_002 PY36_COMMA
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_STAR star_002
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef PY36_COMMA
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef
	| vfpdef PY36_EQUAL test star_002 PY36_COMMA
	| vfpdef PY36_EQUAL test star_002
	| vfpdef star_002 PY36_COMMA PY36_STAR vfpdef star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef PY36_COMMA
	| vfpdef star_002 PY36_COMMA PY36_STAR vfpdef star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef
	| vfpdef star_002 PY36_COMMA PY36_STAR vfpdef star_002 PY36_COMMA
	| vfpdef star_002 PY36_COMMA PY36_STAR vfpdef star_002
	| vfpdef star_002 PY36_COMMA PY36_STAR star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef PY36_COMMA
	| vfpdef star_002 PY36_COMMA PY36_STAR star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef
	| vfpdef star_002 PY36_COMMA PY36_STAR star_002 PY36_COMMA
	| vfpdef star_002 PY36_COMMA PY36_STAR star_002
	| vfpdef star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef PY36_COMMA
	| vfpdef star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef
	| vfpdef star_002 PY36_COMMA
	| vfpdef star_002
	| PY36_STAR vfpdef star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef PY36_COMMA
	| PY36_STAR vfpdef star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef
	| PY36_STAR vfpdef star_002 PY36_COMMA
	| PY36_STAR vfpdef star_002
	| PY36_STAR star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef PY36_COMMA
	| PY36_STAR star_002 PY36_COMMA PY36_DOUBLESTAR vfpdef
	| PY36_STAR star_002 PY36_COMMA
	| PY36_STAR star_002
	| PY36_DOUBLESTAR vfpdef PY36_COMMA
	| PY36_DOUBLESTAR vfpdef
	;
vfpdef // Used in: varargslist, star_002
	: PY36_NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY36_SEMI PY36_NEWLINE
	| small_stmt star_SEMI_small_stmt PY36_NEWLINE
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
	: testlist_star_expr annassign
	| testlist_star_expr augassign yield_expr
	| testlist_star_expr augassign testlist
	| testlist_star_expr star_003
	;
annassign // Used in: expr_stmt
	: PY36_COLON test PY36_EQUAL test
	| PY36_COLON test
	;
testlist_star_expr // Used in: expr_stmt, star_003
	: test star_004 PY36_COMMA
	| test star_004
	| star_expr star_004 PY36_COMMA
	| star_expr star_004
	;
augassign // Used in: expr_stmt
	: PY36_PLUSEQUAL
	| PY36_MINEQUAL
	| PY36_STAREQUAL
	| PY36_ATEQ
	| PY36_SLASHEQUAL
	| PY36_PERCENTEQUAL
	| PY36_AMPEREQUAL
	| PY36_VBAREQUAL
	| PY36_CIRCUMFLEXEQUAL
	| PY36_LEFTSHIFTEQUAL
	| PY36_RIGHTSHIFTEQUAL
	| PY36_DOUBLESTAREQUAL
	| PY36_DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: PY36_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY36_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY36_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY36_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY36_RETURN testlist
	| PY36_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY36_RAISE test PY36_FROM test
	| PY36_RAISE test
	| PY36_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY36_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY36_FROM star_DOT_THREE_DOTS dotted_name PY36_IMPORT PY36_STAR
	| PY36_FROM star_DOT_THREE_DOTS dotted_name PY36_IMPORT PY36_LPAR import_as_names PY36_RPAR
	| PY36_FROM star_DOT_THREE_DOTS dotted_name PY36_IMPORT import_as_names
	| PY36_FROM star_DOT_THREE_DOTS PY36_DOT PY36_IMPORT PY36_STAR
	| PY36_FROM star_DOT_THREE_DOTS PY36_DOT PY36_IMPORT PY36_LPAR import_as_names PY36_RPAR
	| PY36_FROM star_DOT_THREE_DOTS PY36_DOT PY36_IMPORT import_as_names
	| PY36_FROM star_DOT_THREE_DOTS PY36_THREE_DOTS PY36_IMPORT PY36_STAR
	| PY36_FROM star_DOT_THREE_DOTS PY36_THREE_DOTS PY36_IMPORT PY36_LPAR import_as_names PY36_RPAR
	| PY36_FROM star_DOT_THREE_DOTS PY36_THREE_DOTS PY36_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY36_NAME PY36_AS PY36_NAME
	| PY36_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY36_AS PY36_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY36_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY36_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY36_GLOBAL PY36_NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: PY36_NONLOCAL PY36_NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: PY36_ASSERT test PY36_COMMA test
	| PY36_ASSERT test
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
	| async_stmt
	;
async_stmt // Used in: compound_stmt
	: PY36_ASYNC funcdef
	| PY36_ASYNC with_stmt
	| PY36_ASYNC for_stmt
	;
if_stmt // Used in: compound_stmt
	: PY36_IF test PY36_COLON suite star_ELIF PY36_ELSE PY36_COLON suite
	| PY36_IF test PY36_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY36_WHILE test PY36_COLON suite PY36_ELSE PY36_COLON suite
	| PY36_WHILE test PY36_COLON suite
	;
for_stmt // Used in: compound_stmt, async_stmt
	: PY36_FOR exprlist PY36_IN testlist PY36_COLON suite PY36_ELSE PY36_COLON suite
	| PY36_FOR exprlist PY36_IN testlist PY36_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY36_TRY PY36_COLON suite plus_except PY36_ELSE PY36_COLON suite PY36_FINALLY PY36_COLON suite
	| PY36_TRY PY36_COLON suite plus_except PY36_ELSE PY36_COLON suite
	| PY36_TRY PY36_COLON suite plus_except PY36_FINALLY PY36_COLON suite
	| PY36_TRY PY36_COLON suite plus_except
	| PY36_TRY PY36_COLON suite PY36_FINALLY PY36_COLON suite
	;
with_stmt // Used in: compound_stmt, async_stmt
	: PY36_WITH with_item star_COMMA_with_item PY36_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY36_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY36_EXCEPT test PY36_AS PY36_NAME
	| PY36_EXCEPT test
	| PY36_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY36_NEWLINE PY36_INDENT plus_stmt PY36_DEDENT
	;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, annassign, testlist_star_expr, raise_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, lambdef, testlist_comp, subscript, sliceop, testlist, dictorsetmaker, argument, yield_arg, star_001, star_002, star_004, star_ELIF, star_COMMA_test, star_009
	: or_test PY36_IF or_test PY36_ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: PY36_LAMBDA varargslist PY36_COLON test
	| PY36_LAMBDA PY36_COLON test
	;
lambdef_nocond // Used in: test_nocond
	: PY36_LAMBDA varargslist PY36_COLON test_nocond
	| PY36_LAMBDA PY36_COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY36_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY36_LESS
	| PY36_GREATER
	| PY36_EQEQUAL
	| PY36_GREATEREQUAL
	| PY36_LESSEQUAL
	| PY36_GRLT
	| PY36_NOTEQUAL
	| PY36_IN
	| PY36_NOT PY36_IN
	| PY36_IS
	| PY36_IS PY36_NOT
	;
star_expr // Used in: testlist_star_expr, testlist_comp, exprlist, dictorsetmaker, star_004, star_008
	: PY36_STAR expr
	;
expr // Used in: with_item, comparison, star_expr, exprlist, dictorsetmaker, star_comp_op_expr, star_008, star_009
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
	: PY36_PLUS factor
	| PY36_MINUS factor
	| PY36_TILDE factor
	| power
	;
power // Used in: factor
	: atom_expr PY36_DOUBLESTAR factor
	| atom_expr
	;
atom_expr // Used in: power
	: PY36_AWAIT atom star_trailer
	| atom star_trailer
	;
atom // Used in: atom_expr
	: PY36_LPAR yield_expr PY36_RPAR
	| PY36_LPAR testlist_comp PY36_RPAR
	| PY36_LPAR PY36_RPAR
	| PY36_LSQB testlist_comp PY36_RSQB
	| PY36_LSQB PY36_RSQB
	| PY36_LBRACE dictorsetmaker PY36_RBRACE
	| PY36_LBRACE PY36_RBRACE
	| PY36_NAME
	| PY36_NUMBER
	| plus_STRING
	| PY36_THREE_DOTS
	| PY36_NONE
	| PY36_TRUE
	| PY36_FALSE
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_004 PY36_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY36_COMMA
	| star_expr star_004
	;
trailer // Used in: star_trailer
	: PY36_LPAR arglist PY36_RPAR
	| PY36_LPAR PY36_RPAR
	| PY36_LSQB subscriptlist PY36_RSQB
	| PY36_DOT PY36_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY36_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test PY36_COLON test sliceop
	| test PY36_COLON test
	| test PY36_COLON sliceop
	| test PY36_COLON
	| PY36_COLON test sliceop
	| PY36_COLON test
	| PY36_COLON sliceop
	| PY36_COLON
	;
sliceop // Used in: subscript
	: PY36_COLON test
	| PY36_COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_008 PY36_COMMA
	| expr star_008
	| star_expr star_008 PY36_COMMA
	| star_expr star_008
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_arg
	: test star_COMMA_test PY36_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY36_COLON test comp_for
	| test PY36_COLON test star_009 PY36_COMMA
	| test PY36_COLON test star_009
	| PY36_DOUBLESTAR expr comp_for
	| PY36_DOUBLESTAR expr star_009 PY36_COMMA
	| PY36_DOUBLESTAR expr star_009
	| test comp_for
	| test star_004 PY36_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY36_COMMA
	| star_expr star_004
	;
classdef // Used in: decorated, compound_stmt
	: PY36_CLASS PY36_NAME PY36_LPAR arglist PY36_RPAR PY36_COLON suite
	| PY36_CLASS PY36_NAME PY36_LPAR PY36_RPAR PY36_COLON suite
	| PY36_CLASS PY36_NAME PY36_COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: argument star_COMMA_argument PY36_COMMA
	| argument star_COMMA_argument
	;
argument // Used in: arglist, star_COMMA_argument
	: test comp_for
	| test
	| test PY36_EQUAL test
	| PY36_DOUBLESTAR test
	| PY36_STAR test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY36_ASYNC PY36_FOR exprlist PY36_IN or_test comp_iter
	| PY36_ASYNC PY36_FOR exprlist PY36_IN or_test
	| PY36_FOR exprlist PY36_IN or_test comp_iter
	| PY36_FOR exprlist PY36_IN or_test
	;
comp_if // Used in: comp_iter
	: PY36_IF test_nocond comp_iter
	| PY36_IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_003
	: PY36_YIELD yield_arg
	| PY36_YIELD
	;
yield_arg // Used in: yield_expr
	: PY36_FROM test
	| testlist
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY36_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 PY36_COMMA tfpdef PY36_EQUAL test
	| star_001 PY36_COMMA tfpdef
	| %empty
	;
star_002 // Used in: varargslist, star_002
	: star_002 PY36_COMMA vfpdef PY36_EQUAL test
	| star_002 PY36_COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY36_SEMI small_stmt
	| %empty
	;
star_003 // Used in: expr_stmt, star_003
	: star_003 PY36_EQUAL yield_expr
	| star_003 PY36_EQUAL testlist_star_expr
	| %empty
	;
star_004 // Used in: testlist_star_expr, testlist_comp, dictorsetmaker, star_004
	: star_004 PY36_COMMA test
	| star_004 PY36_COMMA star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY36_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY36_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY36_DOT PY36_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY36_COMMA PY36_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY36_ELIF test PY36_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY36_COLON suite
	| except_clause PY36_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY36_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY36_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY36_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY36_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY36_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY36_AMPERSAND shift_expr
	| %empty
	;
star_005 // Used in: shift_expr, star_005
	: star_005 PY36_LEFTSHIFT arith_expr
	| star_005 PY36_RIGHTSHIFT arith_expr
	| %empty
	;
star_006 // Used in: arith_expr, star_006
	: star_006 PY36_PLUS term
	| star_006 PY36_MINUS term
	| %empty
	;
star_007 // Used in: term, star_007
	: star_007 PY36_STAR factor
	| star_007 PY36_AT factor
	| star_007 PY36_SLASH factor
	| star_007 PY36_PERCENT factor
	| star_007 PY36_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: atom_expr, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY36_STRING
	| PY36_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY36_COMMA subscript
	| %empty
	;
star_008 // Used in: exprlist, star_008
	: star_008 PY36_COMMA expr
	| star_008 PY36_COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, star_COMMA_test
	: star_COMMA_test PY36_COMMA test
	| %empty
	;
star_009 // Used in: dictorsetmaker, star_009
	: star_009 PY36_COMMA test PY36_COLON test
	| star_009 PY36_COMMA PY36_DOUBLESTAR expr
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY36_COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS PY36_DOT
	| star_DOT_THREE_DOTS PY36_THREE_DOTS
	| %empty
	;

%%

void py36error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
