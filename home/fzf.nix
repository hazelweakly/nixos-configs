{ pkgs, ... }: {
  programs.fzf =
    let fd = "${pkgs.fd}/bin/fd -HLE .git -c always";
    in
    {
      enable = true;
      changeDirWidgetCommand = "${fd} -td .";
      changeDirWidgetOptions = [
        "--preview '${pkgs.exa}/bin/exa --group-directories-first --icons --sort time --tree --color always {} | ${pkgs.coreutils}/bin/head -200'"
      ];
      defaultCommand = "${fd} -tf 2> /dev/null";
      defaultOptions =
        [ ''--color=''${__sys_theme:-light} --ansi --layout=reverse --inline-info'' ];
      fileWidgetCommand = "${fd} .";
      fileWidgetOptions =
        let
          preview =
            "(${pkgs.bat}/bin/bat --style numbers,changes --color always --paging never {} || ${pkgs.tree}/bin/tree -C {}) 2> /dev/null";
        in
        [ "--preview '${preview} | ${pkgs.coreutils}/bin/head -200'" ];
      historyWidgetOptions = [
        ''--preview 'echo {} | ${pkgs.coreutils}/bin/cut -d\" \" -f2- | ${pkgs.coreutils}/bin/fold -w $(($(${pkgs.ncurses}/bin/tput cols)-4))' --preview-window down:4:hidden --bind '?:toggle-preview${"'"}''
      ];
    };
}
