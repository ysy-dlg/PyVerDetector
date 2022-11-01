#include "scanner.h"
#include <stdlib.h>
#include <string.h>

void init_state(TokenState* t_state)
{
  memset(t_state, 0, sizeof(TokenState));
  t_state->pending_token = NO_TOKEN;
  t_state->indstack[0] = FIRST_COLUMN;
}
