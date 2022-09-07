{ self, inputs, ... }@args:
let
  defaultSpecialArgs = { profiles.work = false; profiles.user.username = "hazelweakly"; };
  mkDarwinSystem = cfg: inputs.nix-darwin.lib.darwinSystem {
    inherit (cfg) inputs system;
    pkgs = self.legacyPackages.${cfg.system};
    modules = import ../modules cfg;
    specialArgs = (cfg.specialArgs or defaultSpecialArgs) // { inherit self; inherit (cfg) hostConfig; };
  };
in
builtins.mapAttrs
  (k: v:
  let a = args // { hostConfig.hostName = builtins.replaceStrings [ "_" ] [ "-" ] k; }; in
  mkDarwinSystem (a // (v a)))
  (self.lib.rake ./.)
