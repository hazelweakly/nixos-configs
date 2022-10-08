{ pkgs, ... }: {
  home.packages = [ pkgs.inputs.self.packages.${pkgs.system}.neovim ];
}
