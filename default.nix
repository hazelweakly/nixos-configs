# let
#   flake = builtins.getFlake (builtins.toString ./.);
#   currentSystem = flake.lib.getCurrentSystem;
#   options = builtins.removeAttrs currentSystem.options [ "_module" ];
#   config = currentSystem.config;
# in
# { inherit config options; }

(import
  (
    let lock = builtins.fromJSON (builtins.readFile ./flake.lock); in
    fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
      sha256 = lock.nodes.flake-compat.locked.narHash;
    }
  )
  { src = ./.; }
).defaultNix
