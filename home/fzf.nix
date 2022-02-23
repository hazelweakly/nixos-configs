{ pkgs, ... }: {
  programs.fzf =
    let fd = "fd -HLE .git -c always";
    in
    {
      enable = true;
      changeDirWidgetCommand = "${fd} -td .";
      changeDirWidgetOptions = [
        "--preview 'exa --group-directories-first --icons --sort time --tree --color always {} | head -200'"
      ];
      defaultCommand = "${fd} -tf 2> /dev/null";
      defaultOptions =
        [ ''--color=''${__sys_theme:-light} --ansi --layout=reverse --inline-info'' ];
      fileWidgetCommand = "${fd} .";
      fileWidgetOptions =
        let
          preview =
            "(bat --style numbers,changes --color always --paging never {} || tree -C {}) 2> /dev/null";
        in
        [ "--preview '${preview} | head -200'" ];
      historyWidgetOptions = [
        ''--preview 'echo {} | cut -d\" \" -f2- | fold -w $(($(tput cols)-4))' --preview-window down:4:hidden --bind '?:toggle-preview${"'"}''
      ];
    };
}
