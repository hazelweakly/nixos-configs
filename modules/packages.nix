{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    curl
    cachix
    file
    timewarrior
    taskwarrior
    ranger
    repl
    openssh
    coreutils
    switch-theme
    _1password
    inputs.self.packages.${pkgs.system}.bitwarden

    docker
    docker-compose

    # Programs implicitly relied on in shell
    pistol
    exa
    delta
    bat
    fd
    ripgrep
    bfs

    # I don't use this yet but I should
    git-absorb
  ] ++
  (with pkgs; lib.optionals stdenv.isLinux [
    firefox-beta-bin
    taskopen
    mupdf
    zoom-us
    htop
    unzip
    wl-clipboard
  ]);

  documentation.dev.enable = true;
}
