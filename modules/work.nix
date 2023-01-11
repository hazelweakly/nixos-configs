{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pulumi-bin
    gum
    packer
    gh
    jq
    dasel
    figlet
    # ansible
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    kubectl
  ];

  homebrew.taps = [ "equinix-labs/otel-cli" "withgraphite/tap" ];
  homebrew.brews = [ "tailscale" "lxc" "otel-cli" "withgraphite/tap/graphite" ];
}
