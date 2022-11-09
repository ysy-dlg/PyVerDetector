#include "scanner.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int init_state(TokenState* t_state, const char* input)
{
  int input_len = strlen(input);
  memset(t_state, 0, sizeof(TokenState));
  t_state->input = (char*)calloc(input_len + 2, sizeof(char));
  t_state->last_error = (char*)calloc(1, sizeof(char));
  if(t_state->input != NULL && t_state->last_error != NULL)
  {
    strncpy(t_state->input, input, input_len);
    t_state->input_len = input_len + 2;
    t_state->pending_token = NO_TOKEN;
    t_state->indstack[0] = FIRST_COLUMN;
    t_state->first_line = 1;
    t_state->first_col = FIRST_COLUMN;
    t_state->last_line = 1;
    t_state->last_col = FIRST_COLUMN;
    return 0;
  }
  else
  {
    return -1;
  }
}

void deinit_state(TokenState* t_state)
{
  if(t_state->last_error != NULL)
  {
    free(t_state->last_error);
    t_state->last_error = NULL;
  }
  if(t_state->input != NULL)
  {
    free(t_state->input);
    t_state->input = NULL;
  }
}

void left_enclose(TokenState* t_state) { ++t_state->level; }

void right_enclose(TokenState* t_state) { --t_state->level; }

void check_bom(TokenState* t_state)
{
  if(t_state->first_line != 1 && t_state->first_col != 1)
    set_error(t_state, "unexpected BOM character");
}

void mark_long_string_start(TokenState* t_state)
{
  t_state->long_string_start_line = t_state->first_line;
  t_state->long_string_start_col = t_state->first_col;
}

void mark_long_string_end(TokenState* t_state)
{
  t_state->first_col = t_state->long_string_start_col;
  t_state->first_line = t_state->long_string_start_line;
  t_state->long_string_start_line = t_state->long_string_start_col = 0;
}

void mark_new_line(TokenState* t_state)
{
  t_state->last_col = FIRST_COLUMN;
  t_state->last_line += 1;
}

bool explicit_newline(TokenState* t_state)
{
  bool is_explicit_newline =
      (t_state->level == 0) &&
      (t_state->cont_line || (t_state->first_col > FIRST_COLUMN));
  t_state->cont_line = false;
  mark_new_line(t_state);
  return is_explicit_newline;
}

void handle_eof(TokenState* t_state)
{
  mark_new_line(t_state); /* Sets current indentation to left margin */
  t_state->last_col = FIRST_COLUMN;
  t_state->first_col = FIRST_COLUMN;
  t_state->atbol = true; /* Triggers flushing of the indentation stack */
}

void set_error(TokenState* t_state, const char* msg)
{
  free(t_state->last_error);
  t_state->last_error = strdup(msg);
}

/* Pop the indentation stack until you get back to col, queue DEDENTs */
void pop_indents(TokenState* t_state, int col)
{
  if(t_state->indent < 0)
  {
    set_error(t_state, "[INTERNAL ERROR] indentation stack underflow");
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
      set_error(t_state, "dedent is less than corresponding indent");
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
  int col = t_state->first_col;
  if(col > curr_indent)
    push_indent(t_state, col);
  else if(col < curr_indent)
    pop_indents(t_state, col);
  /* else col == curr_indent, so do nothing */
}
