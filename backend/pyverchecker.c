#include "scanner.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Automatically updated by the Makefile with the correct amount of versions
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
void string_append_number(String* dst, uint32_t num);
void string_destroy(String src);

#define CHECK_VERSION(X)                                                       \
  init_state(t_state, input);                                                  \
  py##X##lex_init_extra(t_state, &scanner);                                    \
  parser = py##X##pstate_new();                                                \
  do                                                                           \
  {                                                                            \
    token = py##X##_next_token(scanner);                                       \
    if(t_state->last_error[0] != 0x0)                                          \
      break; /* bail out if lexer error */                                     \
    status = py##X##push_parse(parser, token, NULL, t_state);                  \
  } while(status == YYPUSH_MORE);                                              \
  string_append(&retval, "{\"version\":" #X);                                  \
  py##X##pstate_delete(parser);                                                \
  py##X##lex_destroy(scanner);                                                 \
  string_append(&retval, ",\"error\":\"");                                     \
  string_append(&retval, t_state->last_error);                                 \
  string_append(&retval, "\",\"line\":");                                      \
  string_append_number(&retval, (uint32_t)t_state->last_line);                 \
  string_append(&retval, ",\"column\":");                                      \
  string_append_number(&retval, (uint32_t)t_state->first_col);                 \
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
  //>>> Insert CHECK_VERSION(XX) where XX is the version requested <<<//
  // remove the trailing comma on the JSON otherwise javascript cries
  if(retval.c_str[retval.len - 1] == ',')
  {
    retval.c_str[(retval.len--) - 1] = 0x0;
  }
  free(t_state);
  string_append(&retval, "]");
  return retval;
}

#ifdef WASM
char* check_compliance_wasm(const char* input)
{
  String result = check_compliance(input);
  return result.c_str; // needs to be deallocated on the JS side
}
#else
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
#endif

String string_new()
{
  char* c_str = (char*)malloc(STRING_INIT_LEN);
  if(c_str == NULL)
  {
    // TODO: handle error
    exit(EXIT_FAILURE);
  }
  c_str[0] = 0x0;
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

// reverse a string
void reverse(char str[], int length)
{
  int start = 0;
  int end = length - 1;
  while(start < end)
  {
    char tmp = *(str + start);
    *(str + start) = *(str + end);
    *(str + end) = tmp;
    start++;
    end--;
  }
}

void string_append_number(String* dst, uint32_t num)
{
  // itoa implementation
  char buf[11] = "\0";
  if(num == 0)
  {
    buf[0] = '0';
    buf[1] = 0x0;
  }
  else
  {
    int i = 0;
    while(num != 0)
    {
      uint32_t rem = num % 10;
      buf[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
      num = num / 10;
    }
    buf[i] = 0x0;
    reverse(buf, i);
  }
  // append the itoa result to the string
  string_append(dst, buf);
}

void string_destroy(String dst) { free(dst.c_str); }
