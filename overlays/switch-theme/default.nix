final: prev: {
  switch-theme =
    let
      theme = prev.substituteAll {
        src = ./switch-theme;
        kitty_path = builtins.toString ../../dots/kitty;
        isExecutable = true;
      };
    in
    prev.writeScriptBin "switch-theme" (builtins.readFile theme);
}
