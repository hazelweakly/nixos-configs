let
  lock = builtins.fromJSON (builtins.readFile ../flake.lock);
  compat = lock.nodes.flake-compat.locked;
  flake = import (fetchTarball {
    url =
      "https://github.com/edolstra/flake-compat/archive/${compat.rev}.tar.gz";
    sha256 = compat.narHash;
  });
in flake { src = ./..; }
