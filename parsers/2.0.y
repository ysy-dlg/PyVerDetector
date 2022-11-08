%define api.push-pull push
%define api.pure full
%define api.prefix {py20}
%define parse.error verbose
%parse-param{TokenState* t_state}

%code top {
  #include <stdio.h>
  #include <scanner.h>
  #include "2.0.tab.h"
}
%code {
void py20error(TokenState* t_state, const char* msg);
}


// 77 tokens, in alphabetical order:
%token PY20_AMPEREQUAL PY20_AMPERSAND PY20_AND PY20_ASSERT PY20_BACKQUOTE PY20_BAR PY20_BREAK PY20_CIRCUMFLEX PY20_CIRCUMFLEXEQUAL
%token PY20_CLASS PY20_COLON PY20_COMMA PY20_CONTINUE PY20_DEDENT PY20_DEF PY20_DEL PY20_DOT PY20_DOUBLESTAR PY20_DOUBLESTAREQUAL
%token PY20_ELIF PY20_ELSE PY20_ENDMARKER PY20_EQEQUAL PY20_EQUAL PY20_EXCEPT PY20_EXEC PY20_FINALLY PY20_FOR PY20_FROM PY20_GLOBAL
%token PY20_GREATER PY20_GREATEREQUAL PY20_GRLT PY20_IF PY20_IMPORT PY20_IN PY20_INDENT PY20_IS PY20_LAMBDA PY20_LBRACE PY20_LEFTSHIFT
%token PY20_LEFTSHIFTEQUAL PY20_LESS PY20_LESSEQUAL PY20_LPAR PY20_LSQB PY20_MINEQUAL PY20_MINUS PY20_NAME PY20_NEWLINE
%token PY20_NOT PY20_NOTEQUAL PY20_NUMBER PY20_OR PY20_PASS PY20_PERCENT PY20_PERCENTEQUAL PY20_PLUS PY20_PLUSEQUAL PY20_PRINT
%token PY20_RAISE PY20_RBRACE PY20_RETURN PY20_RIGHTSHIFT PY20_RIGHTSHIFTEQUAL PY20_RPAR PY20_RSQB PY20_SEMI PY20_SLASH
%token PY20_SLASHEQUAL PY20_STAR PY20_STAREQUAL PY20_STRING PY20_TILDE PY20_TRY PY20_VBAREQUAL PY20_WHILE

%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt PY20_ENDMARKER
	;
funcdef // Used in: compound_stmt
	: PY20_DEF PY20_NAME parameters PY20_COLON suite
	;
parameters // Used in: funcdef
	: PY20_LPAR varargslist PY20_RPAR
	| PY20_LPAR PY20_RPAR
	;
varargslist // Used in: parameters, lambdef
	: star_fpdef_COMMA PY20_STAR PY20_NAME PY20_COMMA PY20_DOUBLESTAR PY20_NAME
	| star_fpdef_COMMA PY20_STAR PY20_NAME
	| star_fpdef_COMMA PY20_DOUBLESTAR PY20_NAME
	| star_fpdef_COMMA fpdef PY20_EQUAL test PY20_COMMA
	| star_fpdef_COMMA fpdef PY20_EQUAL test
	| star_fpdef_COMMA fpdef PY20_COMMA
	| star_fpdef_COMMA fpdef
	;
fpdef // Used in: varargslist, fplist, star_fpdef_COMMA, star_fpdef_notest
	: PY20_NAME
	| PY20_LPAR fplist PY20_RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest PY20_COMMA
	| fpdef star_fpdef_notest
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt PY20_SEMI PY20_NEWLINE
	| small_stmt star_SEMI_small_stmt PY20_NEWLINE
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
	: PY20_PLUSEQUAL
	| PY20_MINEQUAL
	| PY20_STAREQUAL
	| PY20_SLASHEQUAL
	| PY20_PERCENTEQUAL
	| PY20_AMPEREQUAL
	| PY20_VBAREQUAL
	| PY20_CIRCUMFLEXEQUAL
	| PY20_LEFTSHIFTEQUAL
	| PY20_RIGHTSHIFTEQUAL
	| PY20_DOUBLESTAREQUAL
	;
print_stmt // Used in: small_stmt
	: PY20_PRINT test star_COMMA_test PY20_COMMA
	| PY20_PRINT test star_COMMA_test
	| PY20_PRINT
	| PY20_PRINT PY20_RIGHTSHIFT test plus_COMMA_test PY20_COMMA
	| PY20_PRINT PY20_RIGHTSHIFT test plus_COMMA_test
	| PY20_PRINT PY20_RIGHTSHIFT test
	;
del_stmt // Used in: small_stmt
	: PY20_DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PY20_PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	;
break_stmt // Used in: flow_stmt
	: PY20_BREAK
	;
continue_stmt // Used in: flow_stmt
	: PY20_CONTINUE
	;
return_stmt // Used in: flow_stmt
	: PY20_RETURN testlist
	| PY20_RETURN
	;
raise_stmt // Used in: flow_stmt
	: PY20_RAISE test PY20_COMMA test PY20_COMMA test
	| PY20_RAISE test PY20_COMMA test
	| PY20_RAISE test
	| PY20_RAISE
	;
import_stmt // Used in: small_stmt
	: PY20_IMPORT dotted_as_name star_COMMA_dotted_as_name
	| PY20_FROM dotted_name PY20_IMPORT PY20_STAR
	| PY20_FROM dotted_name PY20_IMPORT import_as_name star_COMMA_import_as_name
	;
import_as_name // Used in: import_stmt, star_COMMA_import_as_name
	: PY20_NAME PY20_NAME PY20_NAME
	| PY20_NAME
	;
dotted_as_name // Used in: import_stmt, star_COMMA_dotted_as_name
	: dotted_name PY20_NAME PY20_NAME
	| dotted_name
	;
dotted_name // Used in: import_stmt, dotted_as_name
	: PY20_NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: PY20_GLOBAL PY20_NAME star_COMMA_NAME
	;
exec_stmt // Used in: small_stmt
	: PY20_EXEC expr PY20_IN test PY20_COMMA test
	| PY20_EXEC expr PY20_IN test
	| PY20_EXEC expr
	;
assert_stmt // Used in: small_stmt
	: PY20_ASSERT test PY20_COMMA test
	| PY20_ASSERT test
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
	: PY20_IF test PY20_COLON suite star_ELIF PY20_ELSE PY20_COLON suite
	| PY20_IF test PY20_COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: PY20_WHILE test PY20_COLON suite PY20_ELSE PY20_COLON suite
	| PY20_WHILE test PY20_COLON suite
	;
for_stmt // Used in: compound_stmt
	: PY20_FOR exprlist PY20_IN testlist PY20_COLON suite PY20_ELSE PY20_COLON suite
	| PY20_FOR exprlist PY20_IN testlist PY20_COLON suite
	;
try_stmt // Used in: compound_stmt
	: PY20_TRY PY20_COLON suite plus_except PY20_ELSE PY20_COLON suite
	| PY20_TRY PY20_COLON suite plus_except
	| PY20_TRY PY20_COLON suite PY20_FINALLY PY20_COLON suite
	;
except_clause // Used in: plus_except
	: PY20_EXCEPT test PY20_COMMA test
	| PY20_EXCEPT test
	| PY20_EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| PY20_NEWLINE PY20_INDENT plus_stmt PY20_DEDENT
	;
test // Used in: varargslist, print_stmt, raise_stmt, exec_stmt, assert_stmt, if_stmt, while_stmt, except_clause, listmaker, lambdef, subscript, sliceop, testlist, dictmaker, arglist, argument, list_if, star_fpdef_COMMA, testlist1, star_COMMA_test, plus_COMMA_test, star_ELIF, star_test_COLON_test
	: and_test star_OR_and_test
	| lambdef
	;
and_test // Used in: test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: PY20_NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: PY20_LESS
	| PY20_GREATER
	| PY20_EQEQUAL
	| PY20_GREATEREQUAL
	| PY20_LESSEQUAL
	| PY20_GRLT
	| PY20_NOTEQUAL
	| PY20_IN
	| PY20_NOT PY20_IN
	| PY20_IS
	| PY20_IS PY20_NOT
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
	: PY20_PLUS factor
	| PY20_MINUS factor
	| PY20_TILDE factor
	| power
	;
power // Used in: factor
	: atom star_trailer PY20_DOUBLESTAR factor
	| atom star_trailer
	;
atom // Used in: power
	: PY20_LPAR testlist PY20_RPAR
	| PY20_LPAR PY20_RPAR
	| PY20_LSQB listmaker PY20_RSQB
	| PY20_LSQB PY20_RSQB
	| PY20_LBRACE dictmaker PY20_RBRACE
	| PY20_LBRACE PY20_RBRACE
	| PY20_BACKQUOTE testlist1 PY20_BACKQUOTE
	| PY20_NAME
	| PY20_NUMBER
	| plus_STRING
	;
listmaker // Used in: atom
	: test list_for
	| test star_COMMA_test PY20_COMMA
	| test star_COMMA_test
	;
lambdef // Used in: test
	: PY20_LAMBDA varargslist PY20_COLON test
	| PY20_LAMBDA PY20_COLON test
	;
trailer // Used in: star_trailer
	: PY20_LPAR arglist PY20_RPAR
	| PY20_LPAR PY20_RPAR
	| PY20_LSQB subscriptlist PY20_RSQB
	| PY20_DOT PY20_NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript PY20_COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: PY20_DOT PY20_DOT PY20_DOT
	| test
	| test PY20_COLON test sliceop
	| test PY20_COLON test
	| test PY20_COLON sliceop
	| test PY20_COLON
	| PY20_COLON test sliceop
	| PY20_COLON test
	| PY20_COLON sliceop
	| PY20_COLON
	;
sliceop // Used in: subscript
	: PY20_COLON test
	| PY20_COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for
	: expr star_COMMA_expr PY20_COMMA
	| expr star_COMMA_expr
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, atom, classdef, list_for, star_EQUAL_testlist
	: test star_COMMA_test PY20_COMMA
	| test star_COMMA_test
	;
dictmaker // Used in: atom
	: test PY20_COLON test star_test_COLON_test PY20_COMMA
	| test PY20_COLON test star_test_COLON_test
	;
classdef // Used in: compound_stmt
	: PY20_CLASS PY20_NAME PY20_LPAR testlist PY20_RPAR PY20_COLON suite
	| PY20_CLASS PY20_NAME PY20_COLON suite
	;
arglist // Used in: trailer
	: star_argument_COMMA argument PY20_COMMA
	| star_argument_COMMA argument
	| star_argument_COMMA PY20_STAR test PY20_COMMA PY20_DOUBLESTAR test
	| star_argument_COMMA PY20_STAR test
	| star_argument_COMMA PY20_DOUBLESTAR test
	;
argument // Used in: arglist, star_argument_COMMA
	: test PY20_EQUAL test
	| test
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: PY20_FOR exprlist PY20_IN testlist list_iter
	| PY20_FOR exprlist PY20_IN testlist
	;
list_if // Used in: list_iter
	: PY20_IF test list_iter
	| PY20_IF test
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef PY20_EQUAL test PY20_COMMA
	| star_fpdef_COMMA fpdef PY20_COMMA
	| %empty
	;
testlist1 // Used in: atom
	: test star_COMMA_test
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt PY20_NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest PY20_COMMA fpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt PY20_SEMI small_stmt
	| %empty
	;
star_EQUAL_testlist // Used in: expr_stmt, star_EQUAL_testlist
	: star_EQUAL_testlist PY20_EQUAL testlist
	| %empty
	;
star_COMMA_test // Used in: print_stmt, listmaker, testlist, testlist1, star_COMMA_test
	: star_COMMA_test PY20_COMMA test
	| %empty
	;
plus_COMMA_test // Used in: print_stmt, plus_COMMA_test
	: plus_COMMA_test PY20_COMMA test
	| PY20_COMMA test
	;
star_COMMA_dotted_as_name // Used in: import_stmt, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name PY20_COMMA dotted_as_name
	| %empty
	;
star_COMMA_import_as_name // Used in: import_stmt, star_COMMA_import_as_name
	: star_COMMA_import_as_name PY20_COMMA import_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME PY20_DOT PY20_NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME PY20_COMMA PY20_NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF PY20_ELIF test PY20_COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause PY20_COLON suite
	| except_clause PY20_COLON suite
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: test, star_OR_and_test
	: star_OR_and_test PY20_OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test PY20_AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr PY20_BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr PY20_CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr PY20_AMPERSAND shift_expr
	| %empty
	;
star_001 // Used in: shift_expr, star_001
	: star_001 PY20_LEFTSHIFT arith_expr
	| star_001 PY20_RIGHTSHIFT arith_expr
	| %empty
	;
star_002 // Used in: arith_expr, star_002
	: star_002 PY20_PLUS term
	| star_002 PY20_MINUS term
	| %empty
	;
star_003 // Used in: term, star_003
	: star_003 PY20_STAR factor
	| star_003 PY20_SLASH factor
	| star_003 PY20_PERCENT factor
	| %empty
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING PY20_STRING
	| PY20_STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript PY20_COMMA subscript
	| %empty
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr PY20_COMMA expr
	| %empty
	;
star_test_COLON_test // Used in: dictmaker, star_test_COLON_test
	: star_test_COLON_test PY20_COMMA test PY20_COLON test
	| %empty
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument PY20_COMMA
	| %empty
	;

%%

void py20error(TokenState* t_state, const char* msg)
{
  set_error(t_state, msg);
}
