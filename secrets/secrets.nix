let
  hazelweakly =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHshmuDCXrzqzGLahxb2flsdOX3Cf3n25903mhiI/B34";
in {
  "galois-onsite-config".publicKeys = [ hazelweakly ];
  "matterhorn-config.ini".publicKeys = [ hazelweakly ];
  "wg-colo".publicKeys = [ hazelweakly ];
  "wg-portland".publicKeys = [ hazelweakly ];
}
