{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    curl
    gitFull
    git-lfs
    cachix
    file
    timewarrior
    taskwarrior
    neovim-remote
    ranger
    repl
    gcc
    openssh
    coreutils
    switch-theme
    _1password

    docker-compose
    awscli2 # yey
    # ssm-session-manager-plugin
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
