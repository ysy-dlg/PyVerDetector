%define api.push-pull push
%define api.pure full
%define api.prefix {py23}
%define parse.error verbose
%parse-param{TokenState* t_state}

%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "2.3.tab.h"
}
%code {
void py23error(TokenState* t_state, const char* msg);
}

// 80 tokens, in alphabetical order:
%token PY23_AMPEREQUAL PY23_AMPERSAND PY23_AND PY23_ASSERT PY23_BACKQUOTE PY23_BAR PY23_BREAK PY23_CIRCUMFLEX PY23_CIRCUMFLEXEQUAL
%token PY23_CLASS PY23_COLON PY23_COMMA PY23_CONTINUE PY23_DEDENT PY23_DEF PY23_DEL PY23_DOT PY23_DOUBLESLASH PY23_DOUBLESLASHEQUAL
%token PY23_DOUBLESTAR PY23_DOUBLESTAREQUAL PY23_ELIF PY23_ELSE PY23_ENDMARKER PY23_EQEQUAL PY23_EQUAL PY23_EXCEPT
%token PY23_EXEC PY23_FINALLY PY23_FOR PY23_FROM PY23_GLOBAL PY23_GREATER PY23_GREATEREQUAL PY23_GRLT PY23_IF PY23_IMPORT
%token PY23_IN PY23_INDENT PY23_IS PY23_LAMBDA PY23_LBRACE PY23_LEFTSHIFT PY23_LEFTSHIFTEQUAL PY23_LESS PY23_LESSEQUAL
%token PY23_LPAR PY23_LSQB PY23_MINEQUAL PY23_MINUS PY23_NAME PY23_NEWLINE PY23_NOT PY23_NOTEQUAL PY23_NUMBER PY23_OR PY23_PASS
%token PY23_PERCENT PY23_PERCENTEQUAL PY23_PLUS PY23_PLUSEQUAL PY23_PRINT PY23_RAISE PY23_RBRACE PY23_RETURN PY23_RIGHTSHIFT
%token PY23_RIGHTSHIFTEQUAL PY23_RPAR PY23_RSQB PY23_SEMI PY23_SLASH PY23_SLASHEQUAL PY23_STAR PY23_STAREQUAL PY23_STRING
%token PY23_TILDE PY23_TRY PY23_VBAREQUAL PY23_WHILE PY23_YIELD

%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY23_ENDMARKER
	;
funcdef // Used in: compound_stmt
	: PY23_DEF PY23_NAME parameters PY23_COLON suite
	;
parameters // Used in: funcdef
	: PY23_LPAR varargslist PY23_RPAR
	| PY23_LPAR PY23_RPAR
	;
varargslist // Used in: parameters, lambdef
	: star_fpdef_COMMA PY23_STAR PY23_NAME PY23_COMMA PY23_DOUBLESTAR PY23_NAME
	| star_fpdef_COMMA PY23_STAR PY23_NAME
	| star_fpdef_COMMA PY23_DOUBLESTAR PY23_NAME
	| star_fpdef_COMMA fpdef PY23_EQUAL test PY23_COMMA
	| star_fpdef_COMMA fpdef PY23_EQUAL test
	| star_fpdef_COMMA fpdef PY23_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY23_NAME
	| PY23_LPAR fplist PY23_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY23_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY23_SEMI PY23_NEWLINE
	| small_stmt star_SEMI_small_stmt PY23_NEWLINE
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
	: testlist augassign testlist
	| testlist star_EQUAL_testlist
	;
augassign // Used in: expr_stmt
	: PY23_PLUSEQUAL
	| PY23_MINEQUAL
	| PY23_STAREQUAL
	| PY23_SLASHEQUAL
	| PY23_PERCENTEQUAL
	| PY23_AMPEREQUAL
	| PY23_VBAREQUAL
	| PY23_CIRCUMFLEXEQUAL
	| PY23_LEFTSHIFTEQUAL
	| PY23_RIGHTSHIFTEQUAL
	| PY23_DOUBLESTAREQUAL
	| PY23_DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PY23_PRINT test star_COMMA_test PY23_COMMA
	| PY23_PRINT test star_COMMA_test
	| PY23_PRINT
	| PY23_PRINT PY23_RIGHTSHIFT test plus_COMMA_test PY23_COMMA
	| PY23_PRINT PY23_RIGHTSHIFT test plus_COMMA_test
	| PY23_PRINT PY23_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY23_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY23_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: PY23_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY23_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY23_RETURN testlist
	| PY23_RETURN
	;
yield_stmt // Used in: flow_stmt
	: PY23_YIELD testlist
	;
raise_stmt // Used in: flow_stmt
	: PY23_RAISE test PY23_COMMA test PY23_COMMA test
	| PY23_RAISE test PY23_COMMA test
	| PY23_RAISE test
	| PY23_RAISE
	;
import_stmt // Used in: small_stmt
	: PY23_IMPORT dotted_as_name star_COMMA_dotted_as_name
	| PY23_FROM dotted_name PY23_IMPORT PY23_STAR
	| PY23_FROM dotted_name PY23_IMPORT import_as_name star_COMMA_import_as_name
	;
import_as_name // Used in: import_stmt, star_COMMA_import_as_name
	: PY23_NAME PY23_NAME PY23_NAME
	| PY23_NAME
	;
dotted_as_name // Used in: import_stmt, star_COMMA_dotted_as_name
	: dotted_name PY23_NAME PY23_NAME
	| dotted_name
	;
dotted_name // Used in: import_stmt, dotted_as_name
	: PY23_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY23_GLOBAL PY23_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY23_EXEC expr PY23_IN test PY23_COMMA test
	| PY23_EXEC expr PY23_IN test
	| PY23_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY23_ASSERT test PY23_COMMA test
	| PY23_ASSERT test
	;
compound_stmt // Used in: stmt
	: if_stmt
	| while_stmt
	| for_stmt
	| try_stmt
	| funcdef
	| classdef
	;
if_stmt // Used in: compound_stmt
	: PY23_IF test PY23_COLON suite star_ELIF PY23_ELSE PY23_COLON suite
	| PY23_IF test PY23_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY23_WHILE test PY23_COLON suite PY23_ELSE PY23_COLON suite
	| PY23_WHILE test PY23_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY23_FOR exprlist PY23_IN testlist PY23_COLON suite PY23_ELSE PY23_COLON suite
	| PY23_FOR exprlist PY23_IN testlist PY23_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY23_TRY PY23_COLON suite plus_except PY23_ELSE PY23_COLON suite
	| PY23_TRY PY23_COLON suite plus_except
	| PY23_TRY PY23_COLON suite PY23_FINALLY PY23_COLON suite
	;
except_clause // Used in: plus_except
	: PY23_EXCEPT test PY23_COMMA test
	| PY23_EXCEPT test
	| PY23_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY23_NEWLINE PY23_INDENT plus_stmt PY23_DEDENT
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, except_clause, listmaker, lambdef, subscript, sliceop, testlist, testlist_safe, dictmaker, arglist, argument, list_if, testlist1, star_fpdef_COMMA, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: and_test star_OR_and_test
	| lambdef
	;
and_test // Used in: test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY23_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY23_LESS
	| PY23_GREATER
	| PY23_EQEQUAL
	| PY23_GREATEREQUAL
	| PY23_LESSEQUAL
	| PY23_GRLT
	| PY23_NOTEQUAL
	| PY23_IN
	| PY23_NOT PY23_IN
	| PY23_IS
	| PY23_IS PY23_NOT
	;
expr // Used in: exec_stmt, comparison, exprlist, star_comp_op_expr, star_COMMA_expr
	: xor_expr star_BAR_xor_expr
	;
xor_expr // Used in: expr, star_BAR_xor_expr
	: and_expr star_CIRCUMFLEX_and_expr
	;
and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: shift_expr star_AMPERSAND_shift_expr
	;
shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: arith_expr star_001
	;
arith_expr // Used in: shift_expr, star_001
	: term star_002
	;
term // Used in: arith_expr, star_002
	: factor star_003
	;
factor // Used in: term, factor, power, star_003
	: PY23_PLUS factor
	| PY23_MINUS factor
	| PY23_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY23_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY23_LPAR testlist PY23_RPAR
	| PY23_LPAR PY23_RPAR
	| PY23_LSQB listmaker PY23_RSQB
	| PY23_LSQB PY23_RSQB
	| PY23_LBRACE dictmaker PY23_RBRACE
	| PY23_LBRACE PY23_RBRACE
	| PY23_BACKQUOTE testlist1 PY23_BACKQUOTE
	| PY23_NAME
	| PY23_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY23_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY23_LAMBDA varargslist PY23_COLON test
	| PY23_LAMBDA PY23_COLON test
	;
trailer // Used in: star_trailer
	: PY23_LPAR arglist PY23_RPAR
	| PY23_LPAR PY23_RPAR
	| PY23_LSQB subscriptlist PY23_RSQB
	| PY23_DOT PY23_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY23_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY23_DOT PY23_DOT PY23_DOT
	| test
	| test PY23_COLON test sliceop
	| test PY23_COLON test
	| test PY23_COLON sliceop
	| test PY23_COLON
	| PY23_COLON test sliceop
	| PY23_COLON test
	| PY23_COLON sliceop
	| PY23_COLON
	;
sliceop // Used in: subscript
	: PY23_COLON test
	| PY23_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for
	: expr star_COMMA_expr PY23_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, yield_stmt, for_stmt, atom, classdef, star_EQUAL_testlist
	: test star_COMMA_test PY23_COMMA
	| test star_COMMA_test
	;
testlist_safe // Used in: list_for
	: test plus_COMMA_test PY23_COMMA
	| test plus_COMMA_test
	| test
	;
dictmaker // Used in: atom
	: test PY23_COLON test star_test_COLON_test PY23_COMMA
	| test PY23_COLON test star_test_COLON_test
	;
classdef // Used in: compound_stmt
	: PY23_CLASS PY23_NAME PY23_LPAR testlist PY23_RPAR PY23_COLON suite
	| PY23_CLASS PY23_NAME PY23_COLON suite
	;
arglist // Used in: trailer
	: star_argument_COMMA argument PY23_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY23_STAR test PY23_COMMA PY23_DOUBLESTAR test
	| star_argument_COMMA PY23_STAR test
	| star_argument_COMMA PY23_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA
	: test PY23_EQUAL test
	| test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY23_FOR exprlist PY23_IN testlist_safe list_iter
	| PY23_FOR exprlist PY23_IN testlist_safe
	;
list_if // Used in: list_iter
	: PY23_IF test list_iter
	| PY23_IF test
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY23_EQUAL test PY23_COMMA
	| star_fpdef_COMMA fpdef PY23_COMMA
	| %empty
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY23_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY23_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY23_SEMI small_stmt
	| %empty
	;
star_EQUAL_testlist // Used in: expr_stmt, star_EQUAL_testlist
	: star_EQUAL_testlist PY23_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist, testlist1, star_COMMA_test
	: star_COMMA_test PY23_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, testlist_safe, plus_COMMA_test
	: plus_COMMA_test PY23_COMMA test
	| PY23_COMMA test
	;
star_COMMA_dotted_as_name // Used in: import_stmt, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY23_COMMA dotted_as_name
	| %empty
	;
star_COMMA_import_as_name // Used in: import_stmt, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY23_COMMA import_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY23_DOT PY23_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY23_COMMA PY23_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY23_ELIF test PY23_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY23_COLON suite
	| except_clause PY23_COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: test, star_OR_and_test
	: star_OR_and_test PY23_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY23_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY23_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY23_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY23_AMPERSAND shift_expr
	| %empty
	;
star_001 // Used in: shift_expr, star_001
	: star_001 PY23_LEFTSHIFT arith_expr
	| star_001 PY23_RIGHTSHIFT arith_expr
	| %empty
	;
star_002 // Used in: arith_expr, star_002
	: star_002 PY23_PLUS term
	| star_002 PY23_MINUS term
	| %empty
	;
star_003 // Used in: term, star_003
	: star_003 PY23_STAR factor
	| star_003 PY23_SLASH factor
	| star_003 PY23_PERCENT factor
	| star_003 PY23_DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY23_STRING
	| PY23_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY23_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY23_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictmaker, star_test_COLON_test
	: star_test_COLON_test PY23_COMMA test PY23_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY23_COMMA
	| %empty
	;

%%

void py23error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
