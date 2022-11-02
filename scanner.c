#include "scanner.h"
#include <stdlib.h>
#include <string.h>

void init_state(TokenState* t_state)
{
  memset(t_state, 0, sizeof(TokenState));
  t_state->pending_token = NO_TOKEN;
  t_state->indstack[0] = FIRST_COLUMN;
}

void left_enclose(TokenState* t_state) { ++t_state->level; }

void right_enclose(TokenState* t_state) { --t_state->level; }

void check_bom(int col_no, int line_no)
{
  if(line_no != 1 && col_no != 1)
    display_error("unexpected BOM character");
}

void mark_long_string_start(TokenState* t_state, int line_no)
{
  t_state->long_string_start_line = line_no;
  t_state->long_string_start_col = t_state->col_no;
}

void mark_long_string_end(TokenState* t_state)
{
  t_state->long_string_start_line = t_state->long_string_start_col = 0;
}

void mark_new_line(TokenState* t_state) { t_state->col_no = FIRST_COLUMN; }

bool explicit_newline(TokenState* t_state)
{
  bool is_explicit_newline =
      (t_state->level == 0) &&
      (t_state->cont_line || (t_state->col_no > FIRST_COLUMN));
  t_state->cont_line = false;
  mark_new_line(t_state);
  return is_explicit_newline;
}

void handle_eof(TokenState* t_state)
{
  mark_new_line(t_state); /* Sets current indentation to left margin */
  t_state->atbol = true;  /* Triggers flushing of the indentation stack */
}

void display_error(const char* msg) {}

/* Pop the indentation stack until you get back to col, queue DEDENTs */
void pop_indents(TokenState* t_state, int col)
{
  if(t_state->indent < 0)
  {
    display_error("(internal) indentation stack underflow");
  }
  else
  {
    int curr_indent = t_state->indstack[t_state->indent];
    if(col < curr_indent)
    {
      t_state->pendin--;
      t_state->indent--; /* The actual 'pop' */
      pop_indents(t_state, col);
    }
    else if(col > curr_indent)
    {
      display_error("dedent is less than corresponding indent");
    }
    /* else col == curr_indent, and we're done */
  }
}

/* Push col onto the indentation stack, queue an INDENT */
void push_indent(TokenState* t_state, int col)
{
  t_state->pendin++;
  t_state->indstack[++t_state->indent] = col;
}

void note_new_indent(TokenState* t_state)
{
  int curr_indent = t_state->indstack[t_state->indent];
  int col = t_state->col_no;
  if(col > curr_indent)
    push_indent(t_state, col);
  else if(col < curr_indent)
    pop_indents(t_state, col);
  /* else col == curr_indent, so do nothing */
}
