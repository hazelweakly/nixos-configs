final: prev: {
  # https://github.com/NixOS/nixpkgs/issues/86349
  # override is required for Crimes reasons because vendorHash is a bitch
  otel-cli = prev.otel-cli.override {
    buildGoModule = args: prev.buildGoModule (args // {
      src = final.inputs.otel-cli;
      version = "0.4.5";
      vendorHash = "sha256-fWQz7ZrU8gulhpOHSN8Prn4EMC0KXy942FZD/PMsLxc=";
    });
  };
}
