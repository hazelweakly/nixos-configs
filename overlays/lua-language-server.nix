final: prev: {
  lua-language-server = prev.lua-language-server.overrideAttrs (o: {
    buildInputs = o.buildInputs ++ [ prev.darwin.ditto ];
  });
}
