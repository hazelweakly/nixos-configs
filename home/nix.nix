{ config, pkgs, lib, ... }: {
  nix.settings.plugin-files = lib.optionals pkgs.stdenv.isLinux [ "${pkgs.nix-doc}/lib/libnix_doc_plugin.so" ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ "${pkgs.nix-doc}/lib/libnix_doc_plugin.dylib" ];
  nix.extraOptions = ''
    !include ${config.age.secrets.mercury.path}
  '';
}
