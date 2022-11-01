#include "3.3.tab.h"
#include "scanner.h"
#include <stdio.h>
#include <stdlib.h>

extern void assign_variables_py33(FILE*, TokenState*);

int check_compliance(int version, const char* filename)
{
  int retval;
  FILE* fin = fopen(filename, "r");
  TokenState* t_state = (TokenState*)malloc(sizeof(TokenState));
  if(t_state == NULL)
  {
    //TODO: handle error
    exit(EXIT_FAILURE);
  }
  init_state(t_state);
  // ADD SWITCH FOR VERSIONS HERE
  assign_variables_py33(fin, t_state);
  //
  free(t_state);
  return retval;
}

int main(int argc, char* argv[])
{
  if(argc != 3) {
    printf("usage: ./pycomply <version> <filename>\n");
    exit(EXIT_FAILURE);
  } else {
    int version = atoi(argv[1]);
    check_compliance(version, argv[2]);
  }
}

