#include "scanner.h"
#include "3.3.lex.h"
#include <stdio.h>
#include <stdlib.h>

extern int py33_next_token(void*);

int check_compliance(int version, const char* input)
{
  int retval;
  TokenState* t_state = (TokenState*)malloc(sizeof(TokenState));
  void* scanner;
  if(t_state == NULL)
  {
    // TODO: handle error
    exit(EXIT_FAILURE);
  }
  init_state(t_state, input);
  // ADD SWITCH FOR VERSIONS HERE
  py33lex_init_extra(t_state, &scanner);
  int token;
  while((token = py33_next_token(scanner)) > 0)
    ;
  py33lex_destroy(scanner);
  //
  deinit_state(t_state);
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
    FILE* fin = fopen(argv[2], "r");
    fseek(fin, 0, SEEK_END);
    int fsize = ftell(fin);
    fseek(fin, 0, SEEK_SET);
    char* input = (char*)calloc(fsize + 1, sizeof(char));
    if(input == NULL)
    {
      fprintf(stderr, "Allocation failed");
      exit(EXIT_FAILURE);
    }
    fread(input, sizeof(char), fsize, fin);
    fclose(fin);
    check_compliance(version, input);
    free(input);
  }
}
