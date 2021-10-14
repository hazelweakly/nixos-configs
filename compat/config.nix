let
  host = (import ./host).config or { };
  # Undo all the configuration additions because otherwise darwin-option chokes

  host_nix = builtins.removeAttrs host.nix [
    "generateNixPathFromInputs"
    "generateRegistryFromInputs"
    "linkInputs"
  ];

  no_pam = builtins.removeAttrs host.security [ "pam" ];
in
(builtins.removeAttrs host [ "home-manager" "nix" "security" ]) // { nix = host_nix; security = no_pam; }
