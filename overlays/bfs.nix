final: prev: {
  bfs = prev.bfs.overrideAttrs (o: {
    preConfigure = prev.lib.optionalString final.stdenv.isDarwin ''
      substituteInPlace GNUmakefile --replace "-flto=auto" ""
    '';
  });
}
