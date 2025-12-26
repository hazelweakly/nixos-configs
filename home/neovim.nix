{ pkgs, ... }: {
  home.packages = [ pkgs.inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.neovim ];
}
