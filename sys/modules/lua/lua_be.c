// SPDX-License-Identifier: MIT
// Copyright (c) 2019 Ulrich Hecht

#include "lua_defs.h"
#include <eb_conio.h>
#include <stdio.h>
#include <string.h>

static int l_cls(lua_State *l) {
  eb_cls();
  eb_locate(0, 0);
  return 0;
}

static int l_basic(lua_State *l) {
  luaL_error(l, "return to basic");
  return 0;
}

int luaopen_be(lua_State *l) {
  lua_pushcfunction(l, l_cls);
  lua_setglobal(l, "cls");
  lua_pushcfunction(l, l_basic);
  lua_setglobal(l, "basic");
  return 0;
}

void do_lua_line(const char *lbuf) {
  char *retline;
  asprintf(&retline, "return %s;", lbuf);
  if ((luaL_loadstring(lua, retline) != LUA_OK &&luaL_loadstring(lua, lbuf) != LUA_OK) ||
      lua_pcall(lua, 0, LUA_MULTRET, 0) != LUA_OK) {
    const char *err_str = lua_tostring(lua, -1);
    if (strstr(err_str, "return to basic")) {
      lua_close(lua);
      lua = NULL;
    } else
      printf("error: %s\n", err_str);
  } else {
    int retvals = lua_gettop(lua);
    if (retvals > 0) {
      luaL_checkstack(lua, LUA_MINSTACK, "too many results to print");
      lua_getglobal(lua, "print");
      lua_insert(lua, 1);
      if (lua_pcall(lua, retvals, 0, 0) != LUA_OK)
        printf("error calling 'print' (%s)\n", lua_tostring(lua, -1));
    }
  }
}

