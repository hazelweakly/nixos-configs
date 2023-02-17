# vendored from this until something like this is merged in
# https://github.com/ryantm/agenix/pull/108
{ config, lib, ... }:

with lib;

let
  osConfig = config;
  hmModule = { config, ... }:
    let
      hmConfig = config;
      secretType = types.submodule ({ config, ... }: {
        options = {
          name = mkOption {
            type = types.str;
            default = config._module.args.name;
            description = ''
              Name of the file
            '';
          };
          file = mkOption {
            type = types.path;
            description = ''
              Age file the secret is loaded from.
            '';
          };
          path = mkOption {
            type = types.str;
            default =
              "${osConfig.age.secretsDir}/hm/${hmConfig.home.username}/${config.name}";
            description = ''
              Path where the decrypted secret is installed.
            '';
          };
          mode = mkOption {
            type = types.str;
            default = "0400";
            description = ''
              Permissions mode of the decrypted secret in a format understood by chmod.
            '';
          };
          symlink = mkEnableOption "symlinking secrets to their destination"
            // {
            default = true;
          };
        };
      });
    in
    {
      options.age = {
        secrets = mkOption {
          type = types.attrsOf secretType;
          default = { };
          description = ''
            Attrset of secrets.
          '';
        };

        identityPaths = mkOption {
          type = types.listOf types.path;
          default = [ ];
          description = ''
            Path to SSH keys to be used as identities in age decryption.
            For homeage this is a no-op and does nothing because we defer to
            the system age module for actual secrets management
          '';
        };
      };
    };
in
{
  home-manager.sharedModules = [ hmModule ];
  age.secrets = mkMerge (flatten (flip mapAttrsToList config.home-manager.users
    (username: userConfig:
      flip mapAttrsToList userConfig.age.secrets (secret: secretConfig: {
        "hm.${username}.${secret}" = {
          inherit (secretConfig) file path mode symlink;
          name = "hm/${username}/${secretConfig.name}";
          owner = username;
        };
      }))));
}
