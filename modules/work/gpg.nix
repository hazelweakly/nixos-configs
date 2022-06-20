{ pkgs, ... }: {
  programs.gnupg.agent.enableSSHSupport = true;

  # copy this so we can "disable" the agent so that it doesn't add stuff to extraInit
  # zsh4humans does this already
  launchd.user.agents.gnupg-agent.serviceConfig = {
    ProgramArguments = [
      "${pkgs.gnupg}/bin/gpg-connect-agent"
      "/bye"
    ];
    RunAtLoad = true;
    KeepAlive.SuccessfulExit = false;
  };

  # Sigh... Guess I still need to do this
  # but at least I can silence the errors until gpg 2.3.3_1 is released
  environment.extraInit = ''
    # SSH agent protocol doesn't support changing TTYs, so bind the agent
    # to every new TTY.
    ${pkgs.gnupg}/bin/gpg-connect-agent --quiet updatestartuptty /bye >/dev/null 2>/dev/null

    export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket 2>/dev/null)
  '';
}
