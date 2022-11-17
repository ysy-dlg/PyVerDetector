%define api.push-pull push
%define api.pure full
%define api.prefix {py38}
%define parse.error verbose
%parse-param{TokenState* t_state}
 
%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "3.8.tab.h"
}
%code {
void py38error(TokenState* t_state, const char* msg);
}
// 89 tokens, in alphabetical order:
%token PY38_AMPEREQUAL PY38_AMPERSAND PY38_AND PY38_ARROW PY38_AS PY38_ASSERT PY38_ASYNC PY38_AT PY38_ATEQ PY38_AWAIT PY38_BAR
%token PY38_BREAK PY38_CIRCUMFLEX PY38_CIRCUMFLEXEQUAL PY38_CLASS PY38_COLON PY38_COMMA PY38_CONTINUE PY38_DEDENT
%token PY38_DEF PY38_DEL PY38_DOT PY38_DOUBLESLASH PY38_DOUBLESLASHEQUAL PY38_DOUBLESTAR PY38_DOUBLESTAREQUAL
%token PY38_ELIF PY38_ELSE PY38_ENDMARKER PY38_EQEQUAL PY38_EQUAL PY38_EXCEPT PY38_FALSE PY38_FINALLY PY38_FOR PY38_FROM PY38_GLOBAL
%token PY38_GREATER PY38_GREATEREQUAL PY38_GRLT PY38_IF PY38_IMPORT PY38_IN PY38_INDENT PY38_IS PY38_LAMBDA PY38_LBRACE PY38_LEFTSHIFT
%token PY38_LEFTSHIFTEQUAL PY38_LESS PY38_LESSEQUAL PY38_LPAR PY38_LSQB PY38_MINEQUAL PY38_MINUS PY38_NAME PY38_NEWLINE
%token PY38_NONE PY38_NONLOCAL PY38_NOT PY38_NOTEQUAL PY38_NUMBER PY38_OR PY38_PASS PY38_PERCENT PY38_PERCENTEQUAL PY38_PLUS
%token PY38_PLUSEQUAL PY38_RAISE PY38_RBRACE PY38_RETURN PY38_RIGHTSHIFT PY38_RIGHTSHIFTEQUAL PY38_RPAR PY38_RSQB
%token PY38_SEMI PY38_SLASH PY38_SLASHEQUAL PY38_STAR PY38_STAREQUAL PY38_STRING PY38_THREE_DOTS PY38_TILDE PY38_TRUE
%token PY38_TRY PY38_VBAREQUAL PY38_WALRUS PY38_WHILE PY38_WITH PY38_YIELD


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY38_ENDMARKER
	;
decorator // Used in: plus_decorator
	: PY38_AT dotted_name PY38_LPAR arglist PY38_RPAR PY38_NEWLINE
	| PY38_AT dotted_name PY38_LPAR PY38_RPAR PY38_NEWLINE
	| PY38_AT dotted_name PY38_NEWLINE
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
	: PY38_ASYNC funcdef
	;
funcdef // Used in: decorated, async_funcdef, compound_stmt, async_stmt
	: PY38_DEF PY38_NAME parameters PY38_ARROW test PY38_COLON suite
	| PY38_DEF PY38_NAME parameters PY38_COLON suite
	;
parameters // Used in: funcdef
	: PY38_LPAR typedargslist PY38_RPAR
	| PY38_LPAR PY38_RPAR
	;
typ_kwargs
  : PY38_DOUBLESTAR tfpdef
  | PY38_DOUBLESTAR tfpdef PY38_COMMA
  ;
typ_args
  : PY38_STAR
  | PY38_STAR tfpdef
  ;
typ_kwonly_kwargs
  : star_001
  | star_001 PY38_COMMA
  | star_001 PY38_COMMA typ_kwargs
  ;
typ_args_kwonly_kwargs
  : typ_args typ_kwonly_kwargs
  | typ_kwargs
  ;
typ_poskeyword_args_kwonly_kwargs
  : tfpdef star_001
  | tfpdef star_001 PY38_COMMA
  | tfpdef star_001 PY38_COMMA typ_args_kwonly_kwargs
  | tfpdef PY38_EQUAL test star_001
  | tfpdef PY38_EQUAL test star_001 PY38_COMMA
  | tfpdef PY38_EQUAL test star_001 PY38_COMMA typ_args_kwonly_kwargs
  ;
typedarglist_no_posonly
  : typ_poskeyword_args_kwonly_kwargs
  | typ_args_kwonly_kwargs
  ;
typedargslist
  : tfpdef star_001 PY38_COMMA PY38_SLASH
  | tfpdef star_001 PY38_COMMA PY38_SLASH PY38_COMMA
  | tfpdef star_001 PY38_COMMA PY38_SLASH PY38_COMMA typedarglist_no_posonly
  | tfpdef PY38_EQUAL test star_001 PY38_COMMA PY38_SLASH
  | tfpdef PY38_EQUAL test star_001 PY38_COMMA PY38_SLASH PY38_COMMA
  | tfpdef PY38_EQUAL test star_001 PY38_COMMA PY38_SLASH PY38_COMMA typedarglist_no_posonly
  | typedarglist_no_posonly
  ;
tfpdef // Used in: typedargslist, star_001
	: PY38_NAME PY38_COLON test
	| PY38_NAME
	;
var_kwargs
  : PY38_DOUBLESTAR vfpdef
  | PY38_DOUBLESTAR vfpdef PY38_COMMA
  ;
var_args
  : PY38_STAR
  | PY38_STAR vfpdef
  ;
var_kwonly_kwargs
  : star_002
  | star_002 PY38_COMMA
  | star_002 PY38_COMMA var_kwargs
  ;
var_args_kwonly_kwargs
  : var_args var_kwonly_kwargs
  | var_kwargs
  ;
var_poskeyword_args_kwonly_kwargs
  : vfpdef star_002
  | vfpdef star_002 PY38_COMMA
  | vfpdef star_002 PY38_COMMA var_args_kwonly_kwargs
  | vfpdef PY38_EQUAL test star_002
  | vfpdef PY38_EQUAL test star_002 PY38_COMMA
  | vfpdef PY38_EQUAL test star_002 PY38_COMMA var_args_kwonly_kwargs
  ;
vararglist_no_posonly
  : var_poskeyword_args_kwonly_kwargs
  | var_args_kwonly_kwargs
  ;
varargslist
  : vfpdef star_002 PY38_COMMA PY38_SLASH
  | vfpdef star_002 PY38_COMMA PY38_SLASH PY38_COMMA
  | vfpdef star_002 PY38_COMMA PY38_SLASH PY38_COMMA vararglist_no_posonly
  | vfpdef PY38_EQUAL test star_002 PY38_COMMA PY38_SLASH
  | vfpdef PY38_EQUAL test star_002 PY38_COMMA PY38_SLASH PY38_COMMA
  | vfpdef PY38_EQUAL test star_002 PY38_COMMA PY38_SLASH PY38_COMMA vararglist_no_posonly
  | vararglist_no_posonly
  ;
vfpdef // Used in: varargslist, star_002
	: PY38_NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY38_SEMI PY38_NEWLINE
	| small_stmt star_SEMI_small_stmt PY38_NEWLINE
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
	: PY38_COLON test PY38_EQUAL yield_expr
  | PY38_COLON test PY38_EQUAL testlist_star_expr
	| PY38_COLON test
	;
testlist_star_expr // Used in: expr_stmt, star_003
	: test star_004 PY38_COMMA
	| test star_004
	| star_expr star_004 PY38_COMMA
	| star_expr star_004
	;
augassign // Used in: expr_stmt
	: PY38_PLUSEQUAL
	| PY38_MINEQUAL
	| PY38_STAREQUAL
	| PY38_ATEQ
	| PY38_SLASHEQUAL
	| PY38_PERCENTEQUAL
	| PY38_AMPEREQUAL
	| PY38_VBAREQUAL
	| PY38_CIRCUMFLEXEQUAL
	| PY38_LEFTSHIFTEQUAL
	| PY38_RIGHTSHIFTEQUAL
	| PY38_DOUBLESTAREQUAL
	| PY38_DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: PY38_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY38_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY38_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY38_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY38_RETURN testlist_star_expr
	| PY38_RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: PY38_RAISE test PY38_FROM test
	| PY38_RAISE test
	| PY38_RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: PY38_IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: PY38_FROM star_DOT_THREE_DOTS dotted_name PY38_IMPORT PY38_STAR
	| PY38_FROM star_DOT_THREE_DOTS dotted_name PY38_IMPORT PY38_LPAR import_as_names PY38_RPAR
	| PY38_FROM star_DOT_THREE_DOTS dotted_name PY38_IMPORT import_as_names
	| PY38_FROM star_DOT_THREE_DOTS PY38_DOT PY38_IMPORT PY38_STAR
	| PY38_FROM star_DOT_THREE_DOTS PY38_DOT PY38_IMPORT PY38_LPAR import_as_names PY38_RPAR
	| PY38_FROM star_DOT_THREE_DOTS PY38_DOT PY38_IMPORT import_as_names
	| PY38_FROM star_DOT_THREE_DOTS PY38_THREE_DOTS PY38_IMPORT PY38_STAR
	| PY38_FROM star_DOT_THREE_DOTS PY38_THREE_DOTS PY38_IMPORT PY38_LPAR import_as_names PY38_RPAR
	| PY38_FROM star_DOT_THREE_DOTS PY38_THREE_DOTS PY38_IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: PY38_NAME PY38_AS PY38_NAME
	| PY38_NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name PY38_AS PY38_NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name PY38_COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: PY38_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY38_GLOBAL PY38_NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: PY38_NONLOCAL PY38_NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: PY38_ASSERT test PY38_COMMA test
	| PY38_ASSERT test
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
	: PY38_ASYNC funcdef
	| PY38_ASYNC with_stmt
	| PY38_ASYNC for_stmt
	;
if_stmt // Used in: compound_stmt
	: PY38_IF namedexpr_test PY38_COLON suite star_ELIF PY38_ELSE PY38_COLON suite
	| PY38_IF namedexpr_test PY38_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY38_WHILE namedexpr_test PY38_COLON suite PY38_ELSE PY38_COLON suite
	| PY38_WHILE namedexpr_test PY38_COLON suite
	;
for_stmt // Used in: compound_stmt, async_stmt
	: PY38_FOR exprlist PY38_IN testlist PY38_COLON suite PY38_ELSE PY38_COLON suite
	| PY38_FOR exprlist PY38_IN testlist PY38_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY38_TRY PY38_COLON suite plus_except PY38_ELSE PY38_COLON suite PY38_FINALLY PY38_COLON suite
	| PY38_TRY PY38_COLON suite plus_except PY38_ELSE PY38_COLON suite
	| PY38_TRY PY38_COLON suite plus_except PY38_FINALLY PY38_COLON suite
	| PY38_TRY PY38_COLON suite plus_except
	| PY38_TRY PY38_COLON suite PY38_FINALLY PY38_COLON suite
	;
with_stmt // Used in: compound_stmt, async_stmt
	: PY38_WITH with_item star_COMMA_with_item PY38_COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test PY38_AS expr
	| test
	;
except_clause // Used in: plus_except
	: PY38_EXCEPT test PY38_AS PY38_NAME
	| PY38_EXCEPT test
	| PY38_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY38_NEWLINE PY38_INDENT plus_stmt PY38_DEDENT
	;

namedexpr_test // Used in if_stmt, while_stmt, testlist_comp, star_ELIF
  : test
  | test PY38_WALRUS test
  ;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, annassign, testlist_star_expr, raise_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, lambdef, subscript, sliceop, testlist, dictorsetmaker, argument, yield_arg, star_001, star_002, star_004, star_ELIF, star_COMMA_test, star_009
	: or_test PY38_IF or_test PY38_ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: PY38_LAMBDA varargslist PY38_COLON test
	| PY38_LAMBDA PY38_COLON test
	;
lambdef_nocond // Used in: test_nocond
	: PY38_LAMBDA varargslist PY38_COLON test_nocond
	| PY38_LAMBDA PY38_COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY38_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY38_LESS
	| PY38_GREATER
	| PY38_EQEQUAL
	| PY38_GREATEREQUAL
	| PY38_LESSEQUAL
	| PY38_GRLT
	| PY38_NOTEQUAL
	| PY38_IN
	| PY38_NOT PY38_IN
	| PY38_IS
	| PY38_IS PY38_NOT
	;
star_expr // Used in: testlist_star_expr, testlist_comp, exprlist, dictorsetmaker, star_004, star_008
	: PY38_STAR expr
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
	: PY38_PLUS factor
	| PY38_MINUS factor
	| PY38_TILDE factor
	| power
	;
power // Used in: factor
	: atom_expr PY38_DOUBLESTAR factor
	| atom_expr
	;
atom_expr // Used in: power
	: PY38_AWAIT atom star_trailer
	| atom star_trailer
	;
atom // Used in: atom_expr
	: PY38_LPAR yield_expr PY38_RPAR
	| PY38_LPAR testlist_comp PY38_RPAR
	| PY38_LPAR PY38_RPAR
	| PY38_LSQB testlist_comp PY38_RSQB
	| PY38_LSQB PY38_RSQB
	| PY38_LBRACE dictorsetmaker PY38_RBRACE
	| PY38_LBRACE PY38_RBRACE
	| PY38_NAME
	| PY38_NUMBER
	| plus_STRING
	| PY38_THREE_DOTS
	| PY38_NONE
	| PY38_TRUE
	| PY38_FALSE
	;
testlist_comp // Used in: atom
	: namedexpr_test comp_for
	| namedexpr_test star_010 PY38_COMMA
	| namedexpr_test star_010
	| star_expr comp_for
	| star_expr star_010 PY38_COMMA
	| star_expr star_010
	;
trailer // Used in: star_trailer
	: PY38_LPAR arglist PY38_RPAR
	| PY38_LPAR PY38_RPAR
	| PY38_LSQB subscriptlist PY38_RSQB
	| PY38_DOT PY38_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY38_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test PY38_COLON test sliceop
	| test PY38_COLON test
	| test PY38_COLON sliceop
	| test PY38_COLON
	| PY38_COLON test sliceop
	| PY38_COLON test
	| PY38_COLON sliceop
	| PY38_COLON
	;
sliceop // Used in: subscript
	: PY38_COLON test
	| PY38_COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_008 PY38_COMMA
	| expr star_008
	| star_expr star_008 PY38_COMMA
	| star_expr star_008
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_arg
	: test star_COMMA_test PY38_COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test PY38_COLON test comp_for
	| test PY38_COLON test star_009 PY38_COMMA
	| test PY38_COLON test star_009
	| PY38_DOUBLESTAR expr comp_for
	| PY38_DOUBLESTAR expr star_009 PY38_COMMA
	| PY38_DOUBLESTAR expr star_009
	| test comp_for
	| test star_004 PY38_COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 PY38_COMMA
	| star_expr star_004
	;
classdef // Used in: decorated, compound_stmt
	: PY38_CLASS PY38_NAME PY38_LPAR arglist PY38_RPAR PY38_COLON suite
	| PY38_CLASS PY38_NAME PY38_LPAR PY38_RPAR PY38_COLON suite
	| PY38_CLASS PY38_NAME PY38_COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: argument star_COMMA_argument PY38_COMMA
	| argument star_COMMA_argument
	;
argument // Used in: arglist, star_COMMA_argument
	: test comp_for
	| test
	| test PY38_EQUAL test
	| test PY38_WALRUS test
	| PY38_DOUBLESTAR test
	| PY38_STAR test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: PY38_ASYNC PY38_FOR exprlist PY38_IN or_test comp_iter
	| PY38_ASYNC PY38_FOR exprlist PY38_IN or_test
	| PY38_FOR exprlist PY38_IN or_test comp_iter
	| PY38_FOR exprlist PY38_IN or_test
	;
comp_if // Used in: comp_iter
	: PY38_IF test_nocond comp_iter
	| PY38_IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_003
	: PY38_YIELD yield_arg
	| PY38_YIELD
	;
yield_arg // Used in: yield_expr
	: PY38_FROM test
	| testlist_star_expr
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY38_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 PY38_COMMA tfpdef PY38_EQUAL test
	| star_001 PY38_COMMA tfpdef
	| %empty
	;
star_002 // Used in: varargslist, star_002
	: star_002 PY38_COMMA vfpdef PY38_EQUAL test
	| star_002 PY38_COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY38_SEMI small_stmt
	| %empty
	;
star_003 // Used in: expr_stmt, star_003
	: star_003 PY38_EQUAL yield_expr
	| star_003 PY38_EQUAL testlist_star_expr
	| %empty
	;
star_004 // Used in: testlist_star_expr, dictorsetmaker, star_004
	: star_004 PY38_COMMA test
	| star_004 PY38_COMMA star_expr
	| %empty
	;
star_010 // Used in: testlist_comp, star_010
	: star_010 PY38_COMMA namedexpr_test
	| star_010 PY38_COMMA star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY38_COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY38_COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY38_DOT PY38_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY38_COMMA PY38_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY38_ELIF namedexpr_test PY38_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY38_COLON suite
	| except_clause PY38_COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item PY38_COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test PY38_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY38_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY38_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY38_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY38_AMPERSAND shift_expr
	| %empty
	;
star_005 // Used in: shift_expr, star_005
	: star_005 PY38_LEFTSHIFT arith_expr
	| star_005 PY38_RIGHTSHIFT arith_expr
	| %empty
	;
star_006 // Used in: arith_expr, star_006
	: star_006 PY38_PLUS term
	| star_006 PY38_MINUS term
	| %empty
	;
star_007 // Used in: term, star_007
	: star_007 PY38_STAR factor
	| star_007 PY38_AT factor
	| star_007 PY38_SLASH factor
	| star_007 PY38_PERCENT factor
	| star_007 PY38_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: atom_expr, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY38_STRING
	| PY38_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY38_COMMA subscript
	| %empty
	;
star_008 // Used in: exprlist, star_008
	: star_008 PY38_COMMA expr
	| star_008 PY38_COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, star_COMMA_test
	: star_COMMA_test PY38_COMMA test
	| %empty
	;
star_009 // Used in: dictorsetmaker, star_009
	: star_009 PY38_COMMA test PY38_COLON test
	| star_009 PY38_COMMA PY38_DOUBLESTAR expr
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument PY38_COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS PY38_DOT
	| star_DOT_THREE_DOTS PY38_THREE_DOTS
	| %empty
	;

%%

void py38error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
