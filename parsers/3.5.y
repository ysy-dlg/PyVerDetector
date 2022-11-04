%define api.push-pull push
%define api.pure full
%define api.prefix {py35}

%code top {
  #include <stdio.h>
  #include "3.5.tab.h"
}
%code {
void py35error(const char* msg);
}

// 89 tokens, in alphabetical order:
%token PY35_AMPEREQUAL PY35_AMPERSAND PY35_AND PY35_ARROW PY35_AS PY35_ASSERT PY35_ASYNC PY35_AT PY35_ATEQ PY35_AWAIT PY35_BAR
%token PY35_BREAK PY35_CIRCUMFLEX PY35_CIRCUMFLEXEQUAL PY35_CLASS PY35_COLON PY35_COMMA PY35_CONTINUE PY35_DEDENT
%token PY35_DEF PY35_DEL PY35_DOT PY35_DOUBLESLASH PY35_DOUBLESLASHEQUAL PY35_DOUBLESTAR PY35_DOUBLESTAREQUAL
%token PY35_ELIF PY35_ELSE PY35_ENDMARKER PY35_EQEQUAL PY35_EQUAL PY35_EXCEPT PY35_FALSE PY35_FINALLY PY35_FOR PY35_FROM PY35_GLOBAL
%token PY35_GREATER PY35_GREATEREQUAL PY35_GRLT PY35_IF PY35_IMPORT PY35_IN PY35_INDENT PY35_IS PY35_LAMBDA PY35_LBRACE PY35_LEFTSHIFT
%token PY35_LEFTSHIFTEQUAL PY35_LESS PY35_LESSEQUAL PY35_LPAR PY35_LSQB PY35_MINEQUAL PY35_MINUS PY35_NAME PY35_NEWLINE
%token PY35_NONE PY35_NONLOCAL PY35_NOT PY35_NOTEQUAL PY35_NUMBER PY35_OR PY35_PASS PY35_PERCENT PY35_PERCENTEQUAL PY35_PLUS
%token PY35_PLUSEQUAL PY35_RAISE PY35_RBRACE PY35_RETURN PY35_RIGHTSHIFT PY35_RIGHTSHIFTEQUAL PY35_RPAR PY35_RSQB
%token PY35_SEMI PY35_SLASH PY35_SLASHEQUAL PY35_STAR PY35_STAREQUAL PY35_STRING PY35_THREE_DOTS PY35_TILDE PY35_TRUE
%token PY35_TRY PY35_VBAREQUAL PY35_WHILE PY35_WITH PY35_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY35_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY35_AT dotted_name PY35_LPAR arglist PY35_RPAR PY35_NEWLINE
	| PY35_AT dotted_name PY35_LPAR PY35_RPAR PY35_NEWLINE
	| PY35_AT dotted_name PY35_NEWLINE
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
	: PY35_ASYNC funcdef
	;
funcdef // Used in: decorated, async_funcdef, compound_stmt, async_stmt
	: PY35_DEF PY35_NAME parameters PY35_ARROW test PY35_COLON suite
	| PY35_DEF PY35_NAME parameters PY35_COLON suite
	;
parameters // Used in: funcdef
	: PY35_LPAR typedargslist PY35_RPAR
	| PY35_LPAR PY35_RPAR
	;
typedargslist // Used in: parameters
	: tfpdef PY35_EQUAL test star_001 PY35_COMMA PY35_STAR tfpdef star_001 PY35_COMMA PY35_DOUBLESTAR tfpdef
	| tfpdef PY35_EQUAL test star_001 PY35_COMMA PY35_STAR tfpdef star_001
	| tfpdef PY35_EQUAL test star_001 PY35_COMMA PY35_STAR star_001 PY35_COMMA PY35_DOUBLESTAR tfpdef
	| tfpdef PY35_EQUAL test star_001 PY35_COMMA PY35_STAR star_001
	| tfpdef PY35_EQUAL test star_001 PY35_COMMA PY35_DOUBLESTAR tfpdef
	| tfpdef PY35_EQUAL test star_001 PY35_COMMA
	| tfpdef PY35_EQUAL test star_001
	| tfpdef star_001 PY35_COMMA PY35_STAR tfpdef star_001 PY35_COMMA PY35_DOUBLESTAR tfpdef
	| tfpdef star_001 PY35_COMMA PY35_STAR tfpdef star_001
	| tfpdef star_001 PY35_COMMA PY35_STAR star_001 PY35_COMMA PY35_DOUBLESTAR tfpdef
	| tfpdef star_001 PY35_COMMA PY35_STAR star_001
	| tfpdef star_001 PY35_COMMA PY35_DOUBLESTAR tfpdef
	| tfpdef star_001 PY35_COMMA
	| tfpdef star_001
	| PY35_STAR tfpdef star_001 PY35_COMMA PY35_DOUBLESTAR tfpdef
	| PY35_STAR tfpdef star_001
	| PY35_STAR star_001 PY35_COMMA PY35_DOUBLESTAR tfpdef
	| PY35_STAR star_001
	| PY35_DOUBLESTAR tfpdef
	;
tfpdef // Used in: typedargslist, star_001
	: PY35_NAME PY35_COLON test
	| PY35_NAME
	;
varargslist // Used in: lambdef, lambdef_nocond
	: vfpdef PY35_EQUAL test star_002 PY35_COMMA PY35_STAR vfpdef star_002 PY35_COMMA PY35_DOUBLESTAR vfpdef
	| vfpdef PY35_EQUAL test star_002 PY35_COMMA PY35_STAR vfpdef star_002
	| vfpdef PY35_EQUAL test star_002 PY35_COMMA PY35_STAR star_002 PY35_COMMA PY35_DOUBLESTAR vfpdef
	| vfpdef PY35_EQUAL test star_002 PY35_COMMA PY35_STAR star_002
	| vfpdef PY35_EQUAL test star_002 PY35_COMMA PY35_DOUBLESTAR vfpdef
	| vfpdef PY35_EQUAL test star_002 PY35_COMMA
	| vfpdef PY35_EQUAL test star_002
	| vfpdef star_002 PY35_COMMA PY35_STAR vfpdef star_002 PY35_COMMA PY35_DOUBLESTAR vfpdef
	| vfpdef star_002 PY35_COMMA PY35_STAR vfpdef star_002
	| vfpdef star_002 PY35_COMMA PY35_STAR star_002 PY35_COMMA PY35_DOUBLESTAR vfpdef
	| vfpdef star_002 PY35_COMMA PY35_STAR star_002
	| vfpdef star_002 PY35_COMMA PY35_DOUBLESTAR vfpdef
	| vfpdef star_002 PY35_COMMA
	| vfpdef star_002
	| PY35_STAR vfpdef star_002 PY35_COMMA PY35_DOUBLESTAR vfpdef
	| PY35_STAR vfpdef star_002
	| PY35_STAR star_002 PY35_COMMA PY35_DOUBLESTAR vfpdef
	| PY35_STAR star_002
	| PY35_DOUBLESTAR vfpdef
	;
vfpdef // Used in: varargslist, star_002
	: PY35_NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY35_SEMI PY35_NEWLINE
	| small_stmt star_SEMI_small_stmt PY35_NEWLINE
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
	: test star_004 PY35_COMMA
	| test star_004
	| star_expr star_004 PY35_COMMA
	| star_expr star_004
	;
augassign // Used in: expr_stmt
	: PY35_PLUSEQUAL
	| PY35_MINEQUAL
	| PY35_STAREQUAL
	| PY35_ATEQ
	| PY35_SLASHEQUAL
	| PY35_PERCENTEQUAL
	| PY35_AMPEREQUAL
	| PY35_VBAREQUAL
	| PY35_CIRCUMFLEXEQUAL
	| PY35_LEFTSHIFTEQUAL
	| PY35_RIGHTSHIFTEQUAL
	| PY35_DOUBLESTAREQUAL
	| PY35_DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: PY35_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY35_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY35_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY35_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY35_RETURN testlist
	| PY35_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY35_RAISE test PY35_FROM test
	| PY35_RAISE test
	| PY35_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY35_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY35_FROM star_DOT_THREE_DOTS dotted_name PY35_IMPORT PY35_STAR
	| PY35_FROM star_DOT_THREE_DOTS dotted_name PY35_IMPORT PY35_LPAR import_as_names PY35_RPAR
	| PY35_FROM star_DOT_THREE_DOTS dotted_name PY35_IMPORT import_as_names
	| PY35_FROM star_DOT_THREE_DOTS PY35_DOT PY35_IMPORT PY35_STAR
	| PY35_FROM star_DOT_THREE_DOTS PY35_DOT PY35_IMPORT PY35_LPAR import_as_names PY35_RPAR
	| PY35_FROM star_DOT_THREE_DOTS PY35_DOT PY35_IMPORT import_as_names
	| PY35_FROM star_DOT_THREE_DOTS PY35_THREE_DOTS PY35_IMPORT PY35_STAR
	| PY35_FROM star_DOT_THREE_DOTS PY35_THREE_DOTS PY35_IMPORT PY35_LPAR import_as_names PY35_RPAR
	| PY35_FROM star_DOT_THREE_DOTS PY35_THREE_DOTS PY35_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY35_NAME PY35_AS PY35_NAME
	| PY35_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY35_AS PY35_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY35_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY35_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY35_GLOBAL PY35_NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: PY35_NONLOCAL PY35_NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: PY35_ASSERT test PY35_COMMA test
	| PY35_ASSERT test
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
	: PY35_ASYNC funcdef
	| PY35_ASYNC with_stmt
	| PY35_ASYNC for_stmt
	;
if_stmt // Used in: compound_stmt
	: PY35_IF test PY35_COLON suite star_ELIF PY35_ELSE PY35_COLON suite
	| PY35_IF test PY35_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY35_WHILE test PY35_COLON suite PY35_ELSE PY35_COLON suite
	| PY35_WHILE test PY35_COLON suite
	;
for_stmt // Used in: compound_stmt, async_stmt
	: PY35_FOR exprlist PY35_IN testlist PY35_COLON suite PY35_ELSE PY35_COLON suite
	| PY35_FOR exprlist PY35_IN testlist PY35_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY35_TRY PY35_COLON suite plus_except PY35_ELSE PY35_COLON suite PY35_FINALLY PY35_COLON suite
	| PY35_TRY PY35_COLON suite plus_except PY35_ELSE PY35_COLON suite
	| PY35_TRY PY35_COLON suite plus_except PY35_FINALLY PY35_COLON suite
	| PY35_TRY PY35_COLON suite plus_except
	| PY35_TRY PY35_COLON suite PY35_FINALLY PY35_COLON suite
	;
with_stmt // Used in: compound_stmt, async_stmt
	: PY35_WITH with_item star_COMMA_with_item PY35_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY35_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY35_EXCEPT test PY35_AS PY35_NAME
	| PY35_EXCEPT test
	| PY35_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY35_NEWLINE PY35_INDENT plus_stmt PY35_DEDENT
	;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, testlist_star_expr, raise_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, lambdef, testlist_comp, subscript, sliceop, testlist, dictorsetmaker, argument, yield_arg, star_001, star_002, star_004, star_ELIF, star_COMMA_test, star_009
	: or_test PY35_IF or_test PY35_ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: PY35_LAMBDA varargslist PY35_COLON test
	| PY35_LAMBDA PY35_COLON test
	;
lambdef_nocond // Used in: test_nocond
	: PY35_LAMBDA varargslist PY35_COLON test_nocond
	| PY35_LAMBDA PY35_COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY35_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY35_LESS
	| PY35_GREATER
	| PY35_EQEQUAL
	| PY35_GREATEREQUAL
	| PY35_LESSEQUAL
	| PY35_GRLT
	| PY35_NOTEQUAL
	| PY35_IN
	| PY35_NOT PY35_IN
	| PY35_IS
	| PY35_IS PY35_NOT
	;
star_expr // Used in: testlist_star_expr, testlist_comp, exprlist, dictorsetmaker, star_004, star_008
	: PY35_STAR expr
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
	: PY35_PLUS factor
	| PY35_MINUS factor
	| PY35_TILDE factor
	| power
	;
power // Used in: factor
	: atom_expr PY35_DOUBLESTAR factor
	| atom_expr
	;
atom_expr // Used in: power
	: PY35_AWAIT atom star_trailer
	| atom star_trailer
	;
atom // Used in: atom_expr
	: PY35_LPAR yield_expr PY35_RPAR
	| PY35_LPAR testlist_comp PY35_RPAR
	| PY35_LPAR PY35_RPAR
	| PY35_LSQB testlist_comp PY35_RSQB
	| PY35_LSQB PY35_RSQB
	| PY35_LBRACE dictorsetmaker PY35_RBRACE
	| PY35_LBRACE PY35_RBRACE
	| PY35_NAME
	| PY35_NUMBER
	| plus_STRING
	| PY35_THREE_DOTS
	| PY35_NONE
	| PY35_TRUE
	| PY35_FALSE
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_004 PY35_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY35_COMMA
	| star_expr star_004
	;
trailer // Used in: star_trailer
	: PY35_LPAR arglist PY35_RPAR
	| PY35_LPAR PY35_RPAR
	| PY35_LSQB subscriptlist PY35_RSQB
	| PY35_DOT PY35_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY35_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test PY35_COLON test sliceop
	| test PY35_COLON test
	| test PY35_COLON sliceop
	| test PY35_COLON
	| PY35_COLON test sliceop
	| PY35_COLON test
	| PY35_COLON sliceop
	| PY35_COLON
	;
sliceop // Used in: subscript
	: PY35_COLON test
	| PY35_COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_008 PY35_COMMA
	| expr star_008
	| star_expr star_008 PY35_COMMA
	| star_expr star_008
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_arg
	: test star_COMMA_test PY35_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY35_COLON test comp_for
	| test PY35_COLON test star_009 PY35_COMMA
	| test PY35_COLON test star_009
	| PY35_DOUBLESTAR expr comp_for
	| PY35_DOUBLESTAR expr star_009 PY35_COMMA
	| PY35_DOUBLESTAR expr star_009
	| test comp_for
	| test star_004 PY35_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY35_COMMA
	| star_expr star_004
	;
classdef // Used in: decorated, compound_stmt
	: PY35_CLASS PY35_NAME PY35_LPAR arglist PY35_RPAR PY35_COLON suite
	| PY35_CLASS PY35_NAME PY35_LPAR PY35_RPAR PY35_COLON suite
	| PY35_CLASS PY35_NAME PY35_COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: argument star_COMMA_argument PY35_COMMA
	| argument star_COMMA_argument
	;
argument // Used in: arglist, star_COMMA_argument
	: test comp_for
	| test
	| test PY35_EQUAL test
	| PY35_DOUBLESTAR test
	| PY35_STAR test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY35_FOR exprlist PY35_IN or_test comp_iter
	| PY35_FOR exprlist PY35_IN or_test
	;
comp_if // Used in: comp_iter
	: PY35_IF test_nocond comp_iter
	| PY35_IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_003
	: PY35_YIELD yield_arg
	| PY35_YIELD
	;
yield_arg // Used in: yield_expr
	: PY35_FROM test
	| testlist
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY35_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 PY35_COMMA tfpdef PY35_EQUAL test
	| star_001 PY35_COMMA tfpdef
	| %empty
	;
star_002 // Used in: varargslist, star_002
	: star_002 PY35_COMMA vfpdef PY35_EQUAL test
	| star_002 PY35_COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY35_SEMI small_stmt
	| %empty
	;
star_003 // Used in: expr_stmt, star_003
	: star_003 PY35_EQUAL yield_expr
	| star_003 PY35_EQUAL testlist_star_expr
	| %empty
	;
star_004 // Used in: testlist_star_expr, testlist_comp, dictorsetmaker, star_004
	: star_004 PY35_COMMA test
	| star_004 PY35_COMMA star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY35_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY35_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY35_DOT PY35_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY35_COMMA PY35_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY35_ELIF test PY35_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY35_COLON suite
	| except_clause PY35_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY35_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY35_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY35_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY35_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY35_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY35_AMPERSAND shift_expr
	| %empty
	;
star_005 // Used in: shift_expr, star_005
	: star_005 PY35_LEFTSHIFT arith_expr
	| star_005 PY35_RIGHTSHIFT arith_expr
	| %empty
	;
star_006 // Used in: arith_expr, star_006
	: star_006 PY35_PLUS term
	| star_006 PY35_MINUS term
	| %empty
	;
star_007 // Used in: term, star_007
	: star_007 PY35_STAR factor
	| star_007 PY35_AT factor
	| star_007 PY35_SLASH factor
	| star_007 PY35_PERCENT factor
	| star_007 PY35_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: atom_expr, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY35_STRING
	| PY35_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY35_COMMA subscript
	| %empty
	;
star_008 // Used in: exprlist, star_008
	: star_008 PY35_COMMA expr
	| star_008 PY35_COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, star_COMMA_test
	: star_COMMA_test PY35_COMMA test
	| %empty
	;
star_009 // Used in: dictorsetmaker, star_009
	: star_009 PY35_COMMA test PY35_COLON test
	| star_009 PY35_COMMA PY35_DOUBLESTAR expr
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY35_COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS PY35_DOT
	| star_DOT_THREE_DOTS PY35_THREE_DOTS
	| %empty
	;

%%

void py35error(const char* msg)
{
}
