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
    github-cli

    # Programs implicitly relied on in shell
    pistol
    exa
    delta
    bat
    fd
    ripgrep
    bfs
  ];
}
