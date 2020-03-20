with { pkgs = import ../nix { }; }; {
  luxi = pkgs.callPackage ../luxi.nix { };
  neovim = pkgs.callPackage ../neovim.nix { };
  firefox = pkgs.latest.firefox-nightly-bin.override { pname = "firefox"; };
  lorri = pkgs.lorri;
  niv = pkgs.niv;
}
