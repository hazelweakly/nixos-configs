final: prev: {
  pmd = prev.pmd.overrideAttrs (o: {
    version = "7.1.0";
    src = builtins.fetchurl {
      url = "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.1.0/pmd-dist-7.1.0-bin.zip";
      # sha256 = prev.lib.fakeHash;
      sha256 = "0m4k0hf7cbaz52msr7arsqk4ycx7crc9y2c7rjaxk18g8mbx4c8d";
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

      mkdir -p $out/share/{zsh/site-functions,bash-completion/completions}
      HOME=.
      $out/bin/pmd generate-completion --zsh > $out/share/zsh/site-functions/_pmd
      $out/bin/pmd generate-completion --bash > $out/share/bash-completion/completions/pmd

      runHook postInstall
    '';
  });
}
