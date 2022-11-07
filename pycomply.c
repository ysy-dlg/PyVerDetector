#include "scanner.h"
#include "versions.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// this line will be replaced by the Makefile with the correct values
const int NUM_VERSIONS = 1;
// minimum len for a string
const int STRING_INIT_LEN = 4;

#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct string
{
  char* c_str;
  uint32_t len;
  uint32_t alloc;
} String;

String string_new();
void string_append(String* dst, const char* src);
void string_destroy(String src);

#define CHECK_VERSION(X)                                                       \
  init_state(t_state, input);                                                  \
  py##X##lex_init_extra(t_state, &scanner);                                    \
  parser = py##X##pstate_new();                                                \
  do                                                                           \
  {                                                                            \
    token = py##X##_next_token(scanner);                                       \
    status = py##X##push_parse(parser, token, NULL);                           \
  } while(status == YYPUSH_MORE);                                              \
  string_append(&retval, "{\"version\":" #X);                                  \
  py##X##pstate_delete(parser);                                                \
  py##X##lex_destroy(scanner);                                                 \
  deinit_state(t_state);                                                       \
  string_append(&retval, "},");

String check_compliance(const char* input)
{
  TokenState* t_state = (TokenState*)malloc(sizeof(TokenState));
  String retval = string_new();
  string_append(&retval, "[");
  void* scanner;
  void* parser;
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
  string_append(&retval, "]");
  return retval;
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
    String result = check_compliance(input);
    free(input);
    printf("%s\n", result.c_str);
    string_destroy(result);
  }
}

String string_new()
{
  char* c_str = (char*)malloc(STRING_INIT_LEN);
  if(c_str == NULL)
  {
    // TODO: handle error
    exit(EXIT_FAILURE);
  }
  String retval = {c_str, 0, STRING_INIT_LEN};
  return retval;
}

void string_append(String* dst, const char* src)
{
  uint32_t len = strlen(src);
  uint32_t required_len = dst->len + len + 1;
  if(required_len > dst->alloc)
  {
    uint32_t new_len = MAX(required_len, dst->alloc * 2);
    dst->c_str = (char*)realloc(dst->c_str, new_len);
  }
  strcat(dst->c_str, src);
  dst->len += len;
}

void string_destroy(String dst) { free(dst.c_str); }
