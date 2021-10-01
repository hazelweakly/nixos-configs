{ pkgs, config, inputs, ... }:
let
  syntaxDirectories = "${inputs.matterhorn}/syntax";
  matterhornNotify = pkgs.writeShellScript "notify" ''
    : "''${1?Mentioned missing}" "''${2?Sender missing}"
    m="''${3?Message missing}"
    urgencies=("" "critical" "normal")
    urgency="''${urgencies[$1]?Error: mentioned value $1 unexpected}"
    ${inputs.notify-send}/src/notify-send.sh -u "$urgency" -f -t 60000 -i ${inputs.matterhorn}/logo/matterhorn-icon.svg -a Matterhorn -c "im.received" "Matterhorn message from $2" "$m"
  '';

  matterhornWrapper =
    let
      urlOpenCommand =
        pkgs.writeShellScript "open" ''exec xdg-open "$@" >/dev/null 2>&1'';
    in
    pkgs.writeShellScriptBin "matterhorn" ''
      source ${./std.sh}
      export urlOpenCommand="${urlOpenCommand}"
      export matterhornNotify="${matterhornNotify}"
      export syntaxDirectories="${syntaxDirectories}"

      f="$(mktemp)"
      cat $XDG_CONFIG_HOME/matterhorn/config-part-*.ini > "$f"
      substituteAllInPlace "$f"
      ln -sf "$f" $XDG_CONFIG_HOME/matterhorn/config.ini
      exec "${pkgs.matterhorn}/bin/matterhorn"
    '';
in
{
  environment.systemPackages = [
    pkgs.aspell
    pkgs.libnotify
    matterhornWrapper
    pkgs.aspellDicts.en
    pkgs.aspellDicts.en-computers
    pkgs.aspellDicts.en-science
  ];

  age.secrets."matterhorn-config.ini".file = ./secrets/matterhorn-config.ini;
  age.secrets."matterhorn-config.ini".owner = "hazel";
  home-manager.users.hazel =
    let cfg = config;
    in
    { config, ... }: {
      xdg.configFile."matterhorn/theme.ini".text = ''
        [default]
        default.bg = default
        [other]
        markdownEmph.style = [italic]
      '';
      xdg.configFile."matterhorn/emoji.json".source = inputs.matterhorn
        + "/emoji/emoji.json";
      xdg.configFile."matterhorn/config-part-1.ini".source =
        config.lib.file.mkOutOfStoreSymlink
          cfg.age.secrets."matterhorn-config.ini".path;

      home.file.".task/hooks/on-modify.timetracking".source =
        pkgs.writeShellScript "on-modify-timewarrior" ''
          PATH=${
            pkgs.python3.withPackages (p: [ p.humanfriendly p.isodate ])
          }/bin:$PATH
          exec python ${dir}/dots/task/time-tracking.py
        '';
      home.file.".task/hooks/on-modify.timewarrior".source =
        pkgs.writeShellScript "on-modify-timewarrior" ''
          PATH=${pkgs.python3}/bin:$PATH
          exec python ${pkgs.timewarrior.outPath}/share/doc/timew/ext/on-modify.timewarrior
        '';
      home.file.".timewarrior/extensions/tt".source =
        pkgs.writeShellScript "totals" ''
          PATH=${pkgs.python3.withPackages (p: [ p.dateutil ])}/bin:$PATH
          exec python ${dir}/dots/task/tt.py
        '';
      home.file.".timewarrior/extensions/totals.py".source =
        pkgs.writeShellScript "totals" ''
          PATH=${pkgs.python3.withPackages (p: [ p.dateutil ])}/bin:$PATH
          exec python ${pkgs.timewarrior.outPath}/share/doc/timew/ext/totals.py
        '';
      home.file.".taskrc".text = ''
        data.location=~/.task

        include ${pkgs.taskwarrior.outPath}/share/doc/task/rc/no-color.theme
        include ~/.task/current.theme

        journal.time=on

        # Shortcuts
        alias.dailystatus=status:completed end.after:today all
        alias.punt=modify wait:1d
        alias.meh=modify due:tomorrow
        alias.someday=mod +someday wait:someday

        search.case.sensitive=no
        alias.burndown=burndown.daily

        # task ready report default with custom columns
        default.command=ready
        report.ready.columns=id,start.active,depends.indicator,project,due.relative,budget,elapsed,description.desc
        report.ready.labels=,,,Project,Due,Left,Spent,Description
        uda.reviewed.type=date
        uda.reviewed.label=Reviewed
        report._reviewed.description=Tasksh review report.  Adjust the filter to your needs.
        report._reviewed.columns=uuid
        report._reviewed.sort=reviewed+,modified+
        report._reviewed.filter=( reviewed.none: or reviewed.before:now-6days ) and ( +PENDING or +WAITING )

        include ~/.task/contexts.txt
        context=no

        # This should be duration but duration doesn't have sane formatting in reports.
        uda.elapsed.label=Time Spent
        uda.elapsed.type=string
        uda.budget.label=Time Left
        uda.budget.type=string

        uda.pl.label=PL
        uda.pl.type=string
        uda.customer.label=Customer
        uda.customer.type=string
      '';
    };
}
