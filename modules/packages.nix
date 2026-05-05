{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [
      cachix
      coreutils
      curl
      file

      kitty
      # openssh
      ranger
      repl

      # Programs implicitly relied on in shell
      eza
      delta
      bat
      fd
      ripgrep
      bfs
    ]
    ++ (with pkgs; lib.optionals (!systemProfile.isWork) [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bitwarden
      jira-cli-go
      switch-theme
      openssh
      taskwarrior3
      timewarrior
      todoist
      otel-cli
      # aider-chat
      repomix
      # xpdf

      pmd

      # Programs implicitly relied on in shell
      parallel
      pistol

      # I don't use this yet but I should
      git-absorb
    ])
    ++ (with pkgs; lib.optionals (systemProfile.isWork) [
    ])
    ++
    (with pkgs; lib.optionals stdenv.isLinux [
      firefox-beta-bin
      htop
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.say
      mupdf
      signal-desktop-beta
      taskopen
      unzip
      wl-clipboard
      xp-pen-deco-01-v2-driver
      zoom-us
    ]) ++
    (with pkgs; lib.optionals stdenv.isDarwin [
    ]);
  }
  (lib.optionalAttrs systemProfile.isLinux {
    documentation.dev.enable = true;
  })
]
