final: prev: {
  victor-mono = prev.runCommandNoCC "victor-mono" { } ''
    mkdir -p $out/share/fonts/truetype
    rm -rf $out/share/fonts/opentype
    ln -sf ${../dots/VictorMono} $out/share/fonts/truetype/victor-mono
  '';
}
