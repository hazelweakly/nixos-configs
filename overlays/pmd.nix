final: prev: {
  pmd = prev.pmd.overrideAttrs (o: {
    version = "7.0.0-rc4";
    src = builtins.fetchurl {
      url = "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.0.0-rc4/pmd-dist-7.0.0-rc4-bin.zip";
      sha256 = "02sphnrc9s741ranb7rvk0rippxi8405yvi4wj4cgw3mx2wmrhc1";
    };
    installPhase = ''
      runHook preInstall

      install -Dm755 bin/pmd $out/bin/pmd
      install -Dm644 lib/* -t $out/lib/pmd/lib
      install -Dm644 conf/* -t $out/lib/pmd/conf

      wrapProgram $out/bin/pmd \
        --prefix PATH : ${prev.openjdk}/bin \
          --set LIB_DIR $out/lib/pmd/lib \
          --set CONF_DIR $out/lib/pmd/conf

      runHook postInstall
    '';
  });
}
