final: prev: {
  switch-theme =
    let
      theme = prev.substituteAll {
        src = ./switch-theme;
        kitty_path = builtins.toString ../../dots/kitty;
        isExecutable = true;
      };
      themeText = builtins.readFile theme;
      text = builtins.substring
        (builtins.stringLength "#!/usr/bin/env bash\n\n")
        (builtins.stringLength themeText)
        themeText;
    in
    prev.writeShellApplication {
      name = "switch-theme";
      runtimeInputs = with prev; [ kitty coreutils neovim-remote ];
      inherit text;
    };
}
