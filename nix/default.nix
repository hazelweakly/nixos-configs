{ sources ? import ./sources.nix }:
let
  moz = import sources.nixpkgs-mozilla;
  niv = _: pkgs: { inherit (import sources.niv { }) niv; };
  lorri = self: super: { lorri = import sources.lorri { pkgs = self; }; };
  nur = self: _: {
    nur = import sources.NUR {
      nurpkgs = self;
      pkgs = self;
    };
  };
  srcs = _: _: { inherit sources; };
  overlays = [ moz nur srcs lorri niv ];
  config = { allowUnfree = true; };
in import sources.nixpkgs { inherit config overlays; }
