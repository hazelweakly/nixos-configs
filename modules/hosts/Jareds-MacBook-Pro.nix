{ self, inputs, ... }: [
  ../../cachix.nix
  inputs.home-manager.darwinModules.home-manager
  ({ lib, ... }: {
    nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") (lib.filterAttrs (_: { outputs ? { }, ... }: outputs ? legacyPackages || outputs ? packages) inputs);
    nix.registry = builtins.mapAttrs (_: v: { flake = v; }) (lib.filterAttrs (_: value: value ? outputs) inputs);
    environment.etc = builtins.listToAttrs (builtins.map (attr: (name: value: { name = "nix/inputs/${name}"; value = { source = value.outPath; }; }) attr inputs.${attr}) (builtins.attrNames inputs));
  })
  {
    nixpkgs.overlays = [ inputs.rust-overlay.overlay (_:_: { inherit inputs; }) ] ++ (builtins.attrValues (self.overlays));
    nix.nixPath = [ "darwin=/etc/nix/inputs/nix-darwin" ]; # doesn't pick up nix-darwin
    environment.darwinConfig = "/etc/nix/inputs/self/compat/config.nix";
    environment.etc.hostname.text = ''
      Hazels-MacBook-Pro
    '';
  }
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.hazelweakly = import ../../home/users/hazelweakly.nix;
    home-manager.users.root = { pkgs, ... }: {
      home.homeDirectory = pkgs.lib.mkForce "/var/root";
      xdg.enable = true;
      programs.zsh.enable = true;
    };
  }
  ../../pam.nix
  ../../nix-darwin.nix
  ../../work.nix
]
