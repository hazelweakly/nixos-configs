{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty.terminfo
    curl
    gitAndTools.gitFull
    git-lfs
    cachix
    file
    timewarrior
    taskwarrior
    myNeovim
    neovim-remote
    ranger
    repl
    gcc
    openssh
    coreutils
    switch-theme
    _1password

    docker
    docker-compose
    awscli2 # yey
    # ssm-session-manager-plugin
    github-cli

    # Programs implicitly relied on in shell
    pistol
    exa
    gitAndTools.delta
    bat
    fd
    ripgrep
    bfs
  ];
}
