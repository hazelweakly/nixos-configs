final: prev: {
  switch-theme =
    let
      theme = prev.replaceVarsWith {
        src = ./switch-theme;
        replacements = {
          kitty_path = builtins.toString ../../dots/kitty;
        };
        isExecutable = true;
      };
    in
    prev.writeShellApplication {
      name = "switch-theme";
      runtimeInputs = with prev; [ kitty coreutils neovim-remote ];
      text = builtins.readFile theme;
    };
}
