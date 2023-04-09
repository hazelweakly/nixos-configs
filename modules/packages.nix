{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [
      _1password
      cachix
      coreutils
      curl
      file
      inputs.self.packages.${pkgs.system}.bitwarden
      kitty
      openssh
      ranger
      repl
      switch-theme
      taskwarrior
      timewarrior

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
      htop
      inputs.self.packages.${pkgs.system}.say
      mupdf
      signal-desktop-beta
      taskopen
      unzip
      wl-clipboard
      zoom-us
    ]);
  }
  (lib.optionalAttrs systemProfile.isLinux {
    documentation.dev.enable = true;
  })
]
