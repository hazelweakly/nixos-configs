{ pkgs, config, ... }: {
  programs.gpg = {
    enable = true;
    scdaemonSettings = { disable-ccid = true; };
  };

  home.file."${config.programs.gpg.homedir}/gpg-agent.conf".text = ''
    default-cache-ttl 60
    max-cache-ttl 120
    enable-ssh-support
  '';
}
