{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [
      # _1password-cli
      cachix
      coreutils
      curl
      file
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bitwarden
      jira-cli-go
      kitty
      openssh
      ranger
      repl
      switch-theme
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
      eza
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
