{ self, inputs, ... }@args: builtins.mapAttrs
  (k: v: v (args // {
    hostConfig.hostName = k;
  }))
  (self.lib.rake ./.)
