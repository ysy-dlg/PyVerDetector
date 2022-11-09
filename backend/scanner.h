#ifndef __SCANNER_H__
#define __SCANNER_H__

typedef char bool;
#ifndef true
#define true 1
#endif
#ifndef false
#define false 0
#endif
#ifndef NULL
#define NULL 0
#endif

/* Used to indicate that no token is queued */
#define NO_TOKEN -1
/* Start a line in column 1 (not 0) */
#define FIRST_COLUMN 1
/* Maximum indentation level in a python file */
#define MAXINDENT 100

/* Current state of the token parser */
typedef struct token_state
{
  int indent;              /* Current indentation index */
  int indstack[MAXINDENT]; /* Stack of indents */
  int atbol;               /* Nonzero if at begin of new line */
  int pendin;              /* Pending indents (if > 0) or dedents (if < 0) */
  int level;               /* () [] {} Parentheses nesting level */
  /* These next state variables are not in the CPython tokeniser state */
  bool cont_line;      /* are we in a continuation line? */
  bool seen_endmarker; /* Have we sent the ENDMARKER token yet? */
  int pending_token;   /* One token can be queued while processing indent/dedent
                        */
  bool seen_future;    /* Importing future module? */
  bool print_name_hack; /* Treat print as a 3.x name? (o/w it is a keyword) */
  char* input; /* Double ASCII-terminated input, used instead of yyin */
  char* last_error;
  int input_len;
  bool assigned_to_yyin; /* true if the input has been assigned to yyin */
  int long_string_start_line;
  int long_string_start_col;
  int first_col;
  int last_col;
  int first_line;
  int last_line;
} TokenState;

int init_state(TokenState* t_state, const char* input);
void deinit_state(TokenState* t_state);
void left_enclose(TokenState* t_state);
void right_enclose(TokenState* t_state);
void mark_long_string_start(TokenState* t_state);
void mark_long_string_end(TokenState* t_state);
void mark_new_line(TokenState* t_state);
bool explicit_newline(TokenState* t_state);
void handle_eof(TokenState* t_state);
void check_bom(TokenState* t_state);
void set_error(TokenState* t_state, const char* msg);
/* Wrapper that calls push or pop as appropriate */
void note_new_indent(TokenState* t_state);
#endif
