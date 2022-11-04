#include "scanner.h"
#include "versions.h"
#include <stdio.h>
#include <stdlib.h>

// this line will be replaced by the Makefile with the correct values
const int NUM_VERSIONS = 1;

#define CHECK_VERSION(X)                                                       \
  init_state(t_state, input);                                                  \
  py##X##lex_init_extra(t_state, &scanner);                                    \
  py##X##pstate* ps##X = py##X##pstate_new();                                  \
  do                                                                           \
  {                                                                            \
    token = py##X##_next_token(scanner);                                       \
    status = py##X##push_parse(ps##X, token, NULL);                            \
  } while(status == YYPUSH_MORE);                                              \
  py##X##pstate_delete(ps##X);                                                 \
  py##X##lex_destroy(scanner);                                                 \
  deinit_state(t_state);

void check_compliance(const char* input)
{
  int retval;
  TokenState* t_state = (TokenState*)malloc(sizeof(TokenState));
  void* scanner;
  int token;
  int status;
  const int results[NUM_VERSIONS];
  if(t_state == NULL)
  {
    // TODO: handle error
    exit(EXIT_FAILURE);
  }
  // this line will be replaced by the Makefile with the correct values
  CHECK_VERSION(0);
  free(t_state);
}

int main(int argc, char* argv[])
{
  if(argc != 2)
  {
    printf("usage: ./pycomply <filename>\n");
    exit(EXIT_FAILURE);
  }
  else
  {
    FILE* fin = fopen(argv[1], "r");
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
    check_compliance(input);
    free(input);
  }
}
