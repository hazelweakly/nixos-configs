with builtins;
rec {
  # from nixpkgs lib
  mapAttrs' = f: set: listToAttrs (map (attr: f attr set.${attr}) (attrNames set));

  removeSuffix = suffix: str:
    let end = if match ".*(${suffix})$" str == null then 0 else stringLength suffix;
    in substring 0 ((stringLength str) - end) str;
  genAttrs' = f: vs: listToAttrs (map f vs);
  genAttrs = ns: f: listToAttrs (map (n: nameValuePair n (f n)) ns);
  nameValuePair = name: value: { inherit name value; };
  filterAttrs = p: s:
    listToAttrs (concatMap (n: if p n s.${n} then [ (nameValuePair n s.${n}) ] else [ ]) (attrNames s));
  inputsWithPkgs = inputs: filterAttrs (_: i: any (a: (i.outputs or { }) ? "${a}") [ "packages" "legacyPackages" ]) inputs;
  inputsWithOutputs = inputs: filterAttrs (_: v: v ? outputs) inputs;
  rake = dir: mapAttrs' (k: v: { name = removeSuffix ".nix" k; value = import (dir + "/${k}"); }) (removeAttrs (readDir dir) [ "default.nix" ]);
}
