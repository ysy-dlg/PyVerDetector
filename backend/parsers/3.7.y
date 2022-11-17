%define api.push-pull push
%define api.pure full
%define api.prefix {py37}
%define parse.error verbose
%parse-param{TokenState* t_state}
 
%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "3.7.tab.h"
}
%code {
void py37error(TokenState* t_state, const char* msg);
}
// 89 tokens, in alphabetical order:
%token PY37_AMPEREQUAL PY37_AMPERSAND PY37_AND PY37_ARROW PY37_AS PY37_ASSERT PY37_ASYNC PY37_AT PY37_ATEQ PY37_AWAIT PY37_BAR
%token PY37_BREAK PY37_CIRCUMFLEX PY37_CIRCUMFLEXEQUAL PY37_CLASS PY37_COLON PY37_COMMA PY37_CONTINUE PY37_DEDENT
%token PY37_DEF PY37_DEL PY37_DOT PY37_DOUBLESLASH PY37_DOUBLESLASHEQUAL PY37_DOUBLESTAR PY37_DOUBLESTAREQUAL
%token PY37_ELIF PY37_ELSE PY37_ENDMARKER PY37_EQEQUAL PY37_EQUAL PY37_EXCEPT PY37_FALSE PY37_FINALLY PY37_FOR PY37_FROM PY37_GLOBAL
%token PY37_GREATER PY37_GREATEREQUAL PY37_GRLT PY37_IF PY37_IMPORT PY37_IN PY37_INDENT PY37_IS PY37_LAMBDA PY37_LBRACE PY37_LEFTSHIFT
%token PY37_LEFTSHIFTEQUAL PY37_LESS PY37_LESSEQUAL PY37_LPAR PY37_LSQB PY37_MINEQUAL PY37_MINUS PY37_NAME PY37_NEWLINE
%token PY37_NONE PY37_NONLOCAL PY37_NOT PY37_NOTEQUAL PY37_NUMBER PY37_OR PY37_PASS PY37_PERCENT PY37_PERCENTEQUAL PY37_PLUS
%token PY37_PLUSEQUAL PY37_RAISE PY37_RBRACE PY37_RETURN PY37_RIGHTSHIFT PY37_RIGHTSHIFTEQUAL PY37_RPAR PY37_RSQB
%token PY37_SEMI PY37_SLASH PY37_SLASHEQUAL PY37_STAR PY37_STAREQUAL PY37_STRING PY37_THREE_DOTS PY37_TILDE PY37_TRUE
%token PY37_TRY PY37_VBAREQUAL PY37_WHILE PY37_WITH PY37_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY37_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY37_AT dotted_name PY37_LPAR arglist PY37_RPAR PY37_NEWLINE
	| PY37_AT dotted_name PY37_LPAR PY37_RPAR PY37_NEWLINE
	| PY37_AT dotted_name PY37_NEWLINE
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
	: PY37_ASYNC funcdef
	;
funcdef // Used in: decorated, async_funcdef, compound_stmt, async_stmt
	: PY37_DEF PY37_NAME parameters PY37_ARROW test PY37_COLON suite
	| PY37_DEF PY37_NAME parameters PY37_COLON suite
	;
parameters // Used in: funcdef
	: PY37_LPAR typedargslist PY37_RPAR
	| PY37_LPAR PY37_RPAR
	;
typedargslist // Used in: parameters
	: tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_STAR tfpdef star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef PY37_COMMA
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_STAR tfpdef star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_STAR tfpdef star_001 PY37_COMMA
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_STAR tfpdef star_001
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_STAR star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef PY37_COMMA
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_STAR star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_STAR star_001 PY37_COMMA
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_STAR star_001
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef PY37_COMMA
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef
	| tfpdef PY37_EQUAL test star_001 PY37_COMMA
	| tfpdef PY37_EQUAL test star_001
	| tfpdef star_001 PY37_COMMA PY37_STAR tfpdef star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef PY37_COMMA
	| tfpdef star_001 PY37_COMMA PY37_STAR tfpdef star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef
	| tfpdef star_001 PY37_COMMA PY37_STAR tfpdef star_001 PY37_COMMA
	| tfpdef star_001 PY37_COMMA PY37_STAR tfpdef star_001
	| tfpdef star_001 PY37_COMMA PY37_STAR star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef PY37_COMMA
	| tfpdef star_001 PY37_COMMA PY37_STAR star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef
	| tfpdef star_001 PY37_COMMA PY37_STAR star_001 PY37_COMMA
	| tfpdef star_001 PY37_COMMA PY37_STAR star_001
	| tfpdef star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef PY37_COMMA
	| tfpdef star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef
	| tfpdef star_001 PY37_COMMA
	| tfpdef star_001
	| PY37_STAR tfpdef star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef PY37_COMMA
	| PY37_STAR tfpdef star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef
	| PY37_STAR tfpdef star_001 PY37_COMMA
	| PY37_STAR tfpdef star_001
	| PY37_STAR star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef PY37_COMMA
	| PY37_STAR star_001 PY37_COMMA PY37_DOUBLESTAR tfpdef
	| PY37_STAR star_001 PY37_COMMA
	| PY37_STAR star_001
	| PY37_DOUBLESTAR tfpdef PY37_COMMA
	| PY37_DOUBLESTAR tfpdef
	;
tfpdef // Used in: typedargslist, star_001
	: PY37_NAME PY37_COLON test
	| PY37_NAME
	;
varargslist // Used in: lambdef, lambdef_nocond
	: vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_STAR vfpdef star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef PY37_COMMA
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_STAR vfpdef star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_STAR vfpdef star_002 PY37_COMMA
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_STAR vfpdef star_002
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_STAR star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef PY37_COMMA
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_STAR star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_STAR star_002 PY37_COMMA
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_STAR star_002
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef PY37_COMMA
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef
	| vfpdef PY37_EQUAL test star_002 PY37_COMMA
	| vfpdef PY37_EQUAL test star_002
	| vfpdef star_002 PY37_COMMA PY37_STAR vfpdef star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef PY37_COMMA
	| vfpdef star_002 PY37_COMMA PY37_STAR vfpdef star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef
	| vfpdef star_002 PY37_COMMA PY37_STAR vfpdef star_002 PY37_COMMA
	| vfpdef star_002 PY37_COMMA PY37_STAR vfpdef star_002
	| vfpdef star_002 PY37_COMMA PY37_STAR star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef PY37_COMMA
	| vfpdef star_002 PY37_COMMA PY37_STAR star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef
	| vfpdef star_002 PY37_COMMA PY37_STAR star_002 PY37_COMMA
	| vfpdef star_002 PY37_COMMA PY37_STAR star_002
	| vfpdef star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef PY37_COMMA
	| vfpdef star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef
	| vfpdef star_002 PY37_COMMA
	| vfpdef star_002
	| PY37_STAR vfpdef star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef PY37_COMMA
	| PY37_STAR vfpdef star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef
	| PY37_STAR vfpdef star_002 PY37_COMMA
	| PY37_STAR vfpdef star_002
	| PY37_STAR star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef PY37_COMMA
	| PY37_STAR star_002 PY37_COMMA PY37_DOUBLESTAR vfpdef
	| PY37_STAR star_002 PY37_COMMA
	| PY37_STAR star_002
	| PY37_DOUBLESTAR vfpdef PY37_COMMA
	| PY37_DOUBLESTAR vfpdef
	;
vfpdef // Used in: varargslist, star_002
	: PY37_NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY37_SEMI PY37_NEWLINE
	| small_stmt star_SEMI_small_stmt PY37_NEWLINE
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
	: PY37_COLON test PY37_EQUAL test
	| PY37_COLON test
	;
testlist_star_expr // Used in: expr_stmt, star_003
	: test star_004 PY37_COMMA
	| test star_004
	| star_expr star_004 PY37_COMMA
	| star_expr star_004
	;
augassign // Used in: expr_stmt
	: PY37_PLUSEQUAL
	| PY37_MINEQUAL
	| PY37_STAREQUAL
	| PY37_ATEQ
	| PY37_SLASHEQUAL
	| PY37_PERCENTEQUAL
	| PY37_AMPEREQUAL
	| PY37_VBAREQUAL
	| PY37_CIRCUMFLEXEQUAL
	| PY37_LEFTSHIFTEQUAL
	| PY37_RIGHTSHIFTEQUAL
	| PY37_DOUBLESTAREQUAL
	| PY37_DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: PY37_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY37_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY37_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY37_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY37_RETURN testlist
	| PY37_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY37_RAISE test PY37_FROM test
	| PY37_RAISE test
	| PY37_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY37_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY37_FROM star_DOT_THREE_DOTS dotted_name PY37_IMPORT PY37_STAR
	| PY37_FROM star_DOT_THREE_DOTS dotted_name PY37_IMPORT PY37_LPAR import_as_names PY37_RPAR
	| PY37_FROM star_DOT_THREE_DOTS dotted_name PY37_IMPORT import_as_names
	| PY37_FROM star_DOT_THREE_DOTS PY37_DOT PY37_IMPORT PY37_STAR
	| PY37_FROM star_DOT_THREE_DOTS PY37_DOT PY37_IMPORT PY37_LPAR import_as_names PY37_RPAR
	| PY37_FROM star_DOT_THREE_DOTS PY37_DOT PY37_IMPORT import_as_names
	| PY37_FROM star_DOT_THREE_DOTS PY37_THREE_DOTS PY37_IMPORT PY37_STAR
	| PY37_FROM star_DOT_THREE_DOTS PY37_THREE_DOTS PY37_IMPORT PY37_LPAR import_as_names PY37_RPAR
	| PY37_FROM star_DOT_THREE_DOTS PY37_THREE_DOTS PY37_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY37_NAME PY37_AS PY37_NAME
	| PY37_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY37_AS PY37_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY37_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY37_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY37_GLOBAL PY37_NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: PY37_NONLOCAL PY37_NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: PY37_ASSERT test PY37_COMMA test
	| PY37_ASSERT test
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
	: PY37_ASYNC funcdef
	| PY37_ASYNC with_stmt
	| PY37_ASYNC for_stmt
	;
if_stmt // Used in: compound_stmt
	: PY37_IF test PY37_COLON suite star_ELIF PY37_ELSE PY37_COLON suite
	| PY37_IF test PY37_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY37_WHILE test PY37_COLON suite PY37_ELSE PY37_COLON suite
	| PY37_WHILE test PY37_COLON suite
	;
for_stmt // Used in: compound_stmt, async_stmt
	: PY37_FOR exprlist PY37_IN testlist PY37_COLON suite PY37_ELSE PY37_COLON suite
	| PY37_FOR exprlist PY37_IN testlist PY37_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY37_TRY PY37_COLON suite plus_except PY37_ELSE PY37_COLON suite PY37_FINALLY PY37_COLON suite
	| PY37_TRY PY37_COLON suite plus_except PY37_ELSE PY37_COLON suite
	| PY37_TRY PY37_COLON suite plus_except PY37_FINALLY PY37_COLON suite
	| PY37_TRY PY37_COLON suite plus_except
	| PY37_TRY PY37_COLON suite PY37_FINALLY PY37_COLON suite
	;
with_stmt // Used in: compound_stmt, async_stmt
	: PY37_WITH with_item star_COMMA_with_item PY37_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY37_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY37_EXCEPT test PY37_AS PY37_NAME
	| PY37_EXCEPT test
	| PY37_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY37_NEWLINE PY37_INDENT plus_stmt PY37_DEDENT
	;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, annassign, testlist_star_expr, raise_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, lambdef, testlist_comp, subscript, sliceop, testlist, dictorsetmaker, argument, yield_arg, star_001, star_002, star_004, star_ELIF, star_COMMA_test, star_009
	: or_test PY37_IF or_test PY37_ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: PY37_LAMBDA varargslist PY37_COLON test
	| PY37_LAMBDA PY37_COLON test
	;
lambdef_nocond // Used in: test_nocond
	: PY37_LAMBDA varargslist PY37_COLON test_nocond
	| PY37_LAMBDA PY37_COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY37_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY37_LESS
	| PY37_GREATER
	| PY37_EQEQUAL
	| PY37_GREATEREQUAL
	| PY37_LESSEQUAL
	| PY37_GRLT
	| PY37_NOTEQUAL
	| PY37_IN
	| PY37_NOT PY37_IN
	| PY37_IS
	| PY37_IS PY37_NOT
	;
star_expr // Used in: testlist_star_expr, testlist_comp, exprlist, dictorsetmaker, star_004, star_008
	: PY37_STAR expr
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
	: PY37_PLUS factor
	| PY37_MINUS factor
	| PY37_TILDE factor
	| power
	;
power // Used in: factor
	: atom_expr PY37_DOUBLESTAR factor
	| atom_expr
	;
atom_expr // Used in: power
	: PY37_AWAIT atom star_trailer
	| atom star_trailer
	;
atom // Used in: atom_expr
	: PY37_LPAR yield_expr PY37_RPAR
	| PY37_LPAR testlist_comp PY37_RPAR
	| PY37_LPAR PY37_RPAR
	| PY37_LSQB testlist_comp PY37_RSQB
	| PY37_LSQB PY37_RSQB
	| PY37_LBRACE dictorsetmaker PY37_RBRACE
	| PY37_LBRACE PY37_RBRACE
	| PY37_NAME
	| PY37_NUMBER
	| plus_STRING
	| PY37_THREE_DOTS
	| PY37_NONE
	| PY37_TRUE
	| PY37_FALSE
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_004 PY37_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY37_COMMA
	| star_expr star_004
	;
trailer // Used in: star_trailer
	: PY37_LPAR arglist PY37_RPAR
	| PY37_LPAR PY37_RPAR
	| PY37_LSQB subscriptlist PY37_RSQB
	| PY37_DOT PY37_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY37_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test PY37_COLON test sliceop
	| test PY37_COLON test
	| test PY37_COLON sliceop
	| test PY37_COLON
	| PY37_COLON test sliceop
	| PY37_COLON test
	| PY37_COLON sliceop
	| PY37_COLON
	;
sliceop // Used in: subscript
	: PY37_COLON test
	| PY37_COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_008 PY37_COMMA
	| expr star_008
	| star_expr star_008 PY37_COMMA
	| star_expr star_008
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_arg
	: test star_COMMA_test PY37_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY37_COLON test comp_for
	| test PY37_COLON test star_009 PY37_COMMA
	| test PY37_COLON test star_009
	| PY37_DOUBLESTAR expr comp_for
	| PY37_DOUBLESTAR expr star_009 PY37_COMMA
	| PY37_DOUBLESTAR expr star_009
	| test comp_for
	| test star_004 PY37_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY37_COMMA
	| star_expr star_004
	;
classdef // Used in: decorated, compound_stmt
	: PY37_CLASS PY37_NAME PY37_LPAR arglist PY37_RPAR PY37_COLON suite
	| PY37_CLASS PY37_NAME PY37_LPAR PY37_RPAR PY37_COLON suite
	| PY37_CLASS PY37_NAME PY37_COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: argument star_COMMA_argument PY37_COMMA
	| argument star_COMMA_argument
	;
argument // Used in: arglist, star_COMMA_argument
	: test comp_for
	| test
	| test PY37_EQUAL test
	| PY37_DOUBLESTAR test
	| PY37_STAR test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY37_ASYNC PY37_FOR exprlist PY37_IN or_test comp_iter
	| PY37_ASYNC PY37_FOR exprlist PY37_IN or_test
	| PY37_FOR exprlist PY37_IN or_test comp_iter
	| PY37_FOR exprlist PY37_IN or_test
	;
comp_if // Used in: comp_iter
	: PY37_IF test_nocond comp_iter
	| PY37_IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_003
	: PY37_YIELD yield_arg
	| PY37_YIELD
	;
yield_arg // Used in: yield_expr
	: PY37_FROM test
	| testlist
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY37_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 PY37_COMMA tfpdef PY37_EQUAL test
	| star_001 PY37_COMMA tfpdef
	| %empty
	;
star_002 // Used in: varargslist, star_002
	: star_002 PY37_COMMA vfpdef PY37_EQUAL test
	| star_002 PY37_COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY37_SEMI small_stmt
	| %empty
	;
star_003 // Used in: expr_stmt, star_003
	: star_003 PY37_EQUAL yield_expr
	| star_003 PY37_EQUAL testlist_star_expr
	| %empty
	;
star_004 // Used in: testlist_star_expr, testlist_comp, dictorsetmaker, star_004
	: star_004 PY37_COMMA test
	| star_004 PY37_COMMA star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY37_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY37_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY37_DOT PY37_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY37_COMMA PY37_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY37_ELIF test PY37_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY37_COLON suite
	| except_clause PY37_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY37_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY37_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY37_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY37_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY37_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY37_AMPERSAND shift_expr
	| %empty
	;
star_005 // Used in: shift_expr, star_005
	: star_005 PY37_LEFTSHIFT arith_expr
	| star_005 PY37_RIGHTSHIFT arith_expr
	| %empty
	;
star_006 // Used in: arith_expr, star_006
	: star_006 PY37_PLUS term
	| star_006 PY37_MINUS term
	| %empty
	;
star_007 // Used in: term, star_007
	: star_007 PY37_STAR factor
	| star_007 PY37_AT factor
	| star_007 PY37_SLASH factor
	| star_007 PY37_PERCENT factor
	| star_007 PY37_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: atom_expr, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY37_STRING
	| PY37_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY37_COMMA subscript
	| %empty
	;
star_008 // Used in: exprlist, star_008
	: star_008 PY37_COMMA expr
	| star_008 PY37_COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, star_COMMA_test
	: star_COMMA_test PY37_COMMA test
	| %empty
	;
star_009 // Used in: dictorsetmaker, star_009
	: star_009 PY37_COMMA test PY37_COLON test
	| star_009 PY37_COMMA PY37_DOUBLESTAR expr
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY37_COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS PY37_DOT
	| star_DOT_THREE_DOTS PY37_THREE_DOTS
	| %empty
	;

%%

void py37error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
