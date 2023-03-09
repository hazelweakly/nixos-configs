{ config, pkgs, ... }: {
  nix.settings.plugin-files = [ "${pkgs.nix-doc}/lib/libnix_doc_plugin.so" ];
  nix.extraOptions = ''
    !include ${config.age.secrets.mercury.path}
  '';
}
