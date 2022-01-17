final: prev: {
  lua-nuspell = prev.luajit_2_1.pkgs.buildLuarocksPackage {
    pname = "lua-nuspell";
    version = "0.3alpha-1";
    knownRockspec = (prev.fetchurl {
      url = "https://luarocks.org/lua-nuspell-0.3alpha-1.rockspec";
      sha256 = "0vzvm7nmwvm6w05qgd9ryhkag31ja1znl9mhaw3pk23a6dkvlbya";
    }).outPath;
    src = prev.fetchgit (builtins.removeAttrs
      (builtins.fromJSON ''{
  "url": "https://github.com/f3fora/lua-nuspell.git",
  "rev": "505b291070282c3942f85b758c1f319b253969c4",
  "date": "2021-08-30T20:49:39+02:00",
  "path": "/nix/store/ajazvvqi4nlffi23pc494l5c0a3gzbki-lua-nuspell",
  "sha256": "0kapwbn2wvvzcn51695a2fp4yf2givrscr8rrypbl3lq7phj95vp",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') [ "date" "path" ]);

    disabled = with prev.luajit_2_1.pkgs.lib; (luaOlder "5.1");

    extraVariables = {
      LUA_LIBDIR = "${prev.luajit_2_1.pkgs.lua}/lib/";
      LUA_INCDIR = "${prev.luajit_2_1.pkgs.lua}/include/";
      LUA_LIBDIR_FILE = "libluajit-5.1.dylib";
      CMAKE_BUILD_TYPE = "Release";
    };

    propagatedBuildInputs = [ prev.luajit_2_1.pkgs.lua prev.cmake prev.icu ] ++ prev.nuspell.all;

    meta = {
      homepage = "https://github.com/f3fora/lua-nuspell";
      description = "lua bindings for Nuspell";
      license.fullName = "GNU LGPL v3";
    };
  };
}
