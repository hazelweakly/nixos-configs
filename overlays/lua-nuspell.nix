final: prev: {
  lua-nuspell = prev.luajit_2_1.pkgs.buildLuarocksPackage {
    pname = "lua-nuspell";
    version = "0.3alpha-1";
    knownRockspec = (prev.fetchurl {
      url = "https://luarocks.org/lua-nuspell-0.3alpha-1.rockspec";
      sha256 = "0vzvm7nmwvm6w05qgd9ryhkag31ja1znl9mhaw3pk23a6dkvlbya";
    }).outPath;
    src = prev.fetchFromGitHub {
      owner = "f3fora";
      repo = "lua-nuspell";
      rev = "9fe6855eb99d0714367234b7b4fce9dffec7d408";
      sha256 = "zIRHfXjOQpl6sWwGD0JdpeSFcN9PssGfT6W+Cky+boI=";
    };

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
