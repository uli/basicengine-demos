// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Ulrich Hecht

#include <stdint.h>

#include "lua_defs.h"
#include <eb_basic.h>
#include <eb_conio.h>
#include <eb_sys.h>
#include <error.h>

#include <stdlib.h>

lua_State *lua = NULL;

static void lhook(lua_State *L, lua_Debug *ar) {
  (void)ar;
  if (eb_process_events_check())
    luaL_error(L, "interrupted!");
}

void lua_cmd(const eb_param_t *params) {
  lua = luaL_newstate();
  if (!lua) {
    eb_set_error(ERR_SYS, NULL);
    return;
  }

  luaL_openlibs(lua);
  luaopen_be(lua);
  luaopen_bg(lua);
  luaopen_img(lua);
  luaopen_input(lua);
  luaopen_video(lua);
  luaopen_hwio(lua);
  lua_sethook(lua, lhook, LUA_MASKCOUNT, 1000);

  char *line;
  while (lua != NULL) {
    printf("ok\n");
    eb_show_cursor(1);
    line = eb_screened_get_line();
    eb_show_cursor(0);
    eb_putch('\n');
    if (line) {
      do_lua_line(line);
      free(line);
    }
  }
}

static const enum token_t lua_syntax[] = { I_EOL };

void __initcall(void) {
  eb_add_command("LUA", lua_syntax, lua_cmd);
}
