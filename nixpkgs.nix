with { sources = import ./nix/sources.nix; };
let
  moz = import sources.nixpkgs-mozilla;
  nur = self: super: {
    nur = (super.nur or { }) // import sources.NUR {
      nurpkgs = self;
      pkgs = self;
    };
  };
  config = { allowUnfree = true; };
in {
  nixpkgs.config = config;
  nixpkgs.overlays = [ moz nur ];
  nixpkgs.pkgs = import sources.nixpkgs { inherit config; };
  nix.nixPath = [
    "nixpkgs=${sources.nixpkgs}"
    "nixos-config=/etc/nixos/configuration.nix"
  ];
}
