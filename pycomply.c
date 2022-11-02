#include "scanner.h"
#include "3.3.lex.h"
#include <stdio.h>
#include <stdlib.h>

extern int py33_next_token(void*);

int check_compliance(int version, const char* filename)
{
  int retval;
  FILE* fin = fopen(filename, "r");
  TokenState* t_state = (TokenState*)malloc(sizeof(TokenState));
  void* scanner;
  if(t_state == NULL)
  {
    // TODO: handle error
    exit(EXIT_FAILURE);
  }
  init_state(t_state);
  // ADD SWITCH FOR VERSIONS HERE
  py33lex_init_extra(t_state, &scanner);
  int token;
  while((token = py33_next_token(&scanner)) > 0)
  {
    printf("Recognized %d", token);
  }
  py33lex_destroy(&scanner);
  //
  free(t_state);
  return retval;
}

int main(int argc, char* argv[])
{
  if(argc != 3)
  {
    printf("usage: ./pycomply <version> <filename>\n");
    exit(EXIT_FAILURE);
  }
  else
  {
    int version = atoi(argv[1]);
    check_compliance(version, argv[2]);
  }
}
