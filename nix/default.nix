{ sources ? import ./sources.nix }:

let
  moz = import sources.nixpkgs-mozilla;
  nur = self: super: {
    nur = (super.nur or { }) // import sources.NUR {
      nurpkgs = self;
      pkgs = self;
    };
  };

in import sources.nixpkgs {
  overlays = [ moz nur ];
  config.allowUnfree = true;
}
