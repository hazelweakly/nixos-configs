with builtins;
rec {
  removeSuffix = suffix: str: substring 0 ((stringLength str) - (stringLength suffix)) str;
  genAttrs' = f: vs: listToAttrs (map f vs);
  genAttrs = ns: f: listToAttrs (map (n: nameValuePair n (f n)) ns);
  nameValuePair = name: value: { inherit name value; };
  filterAttrs = p: s:
    listToAttrs (concatMap (n: if p n s.${n} then [ (nameValuePair n s.${n}) ] else [ ]) (attrNames s));
  inputsWithPkgs = inputs: filterAttrs (_: i: any (a: (i.outputs or { }) ? "${a}") [ "packages" "legacyPackages" ]) inputs;
  inputsWithOutputs = inputs: filterAttrs (_: v: v ? outputs) inputs;
  rake = dir: genAttrs (map (removeSuffix ".nix") (attrNames (removeAttrs (readDir dir) [ "default.nix" ]))) (f: import (dir + "/${f}.nix"));
}
