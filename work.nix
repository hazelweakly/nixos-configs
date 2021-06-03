{ pkgs, config, inputs, ... }:
let
  syntaxDirectories = "${inputs.matterhorn}/syntax";
  matterhornNotify = pkgs.writeShellScript "notify" ''
    : "''${1?Mentioned missing}" "''${2?Sender missing}"
    m="''${3?Message missing}"
    urgencies=("" "critical" "normal")
    urgency="''${urgencies[$1]?Error: mentioned value $1 unexpected}"
    PATH=${pkgs.bc}/bin:$PATH
    /home/hazel/src/personal/notify-send.sh/notify-send.sh -u "$urgency" -f -t 60000 -i ${inputs.matterhorn}/logo/matterhorn-icon.svg -a Matterhorn -c "im.received" -- "Matterhorn message from $2" "$m"
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
  boot.plymouth.logo = ./dots/galois.png;

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

      programs.git = {
        userName = pkgs.lib.mkForce "Hazel Weakly";
        userEmail = pkgs.lib.mkForce "hazel@theweaklys.com";
        includes = [{
          condition = "gitdir:~/src/personal/";
          contents = {
            user = {
              name = "hazelweakly";
              email = "hazel@theweaklys.com";
            };
          };
        }];
      };
    };
}
