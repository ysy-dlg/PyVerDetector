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
  int long_string_start_line; /* Starting line for a multi-line string */
  int long_string_start_col;  /* Starting column for a multi-line string */
} TokenState;

void init_state(TokenState* t_state);

#endif
