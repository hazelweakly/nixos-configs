{ config, pkgs, ... }:
with builtins;
with pkgs.lib;
let
  fahService = c: s: {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "default.target" ];
    path = [ pkgs.foldingathome ];
    script = "FAHClient --send-${c}";
    startAt = "*-*-* ${s}";
  };
in {
  services.foldingathome.enable = true;
  services.foldingathome.team = 242964;
  services.foldingathome.user = "Hazel Weakly";
  services.foldingathome.extraArgs = [ "--pause-on-start=true" ];

  systemd.services.start-fah = fahService "unpause" "22:00";
  systemd.services.pause-fah = fahService "pause" "06:30";
}
