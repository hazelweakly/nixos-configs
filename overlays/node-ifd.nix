final: prev:

let

  node2nix = final.inputs.node2nix.packages.${final.system}.node2nix;

  ifd =
    { runCommand
    , nodejs
    , nodePackages
    , pkgs
    , lib
    }:

    let src_tree = ../nodePackages; in

    rec {
      nodeVersion = builtins.elemAt (lib.versions.splitVersion nodejs.version) 0;
      node2nixDrv = runCommand "node2nix" { } ''
        mkdir $out
        ${node2nix}/bin/node2nix \
        --input ${src_tree}/package.json \
        --lock ${src_tree}/package-lock.json \
        --node-env $out/node-env.nix \
        --output $out/node-packages.nix \
        --composition $out/default.nix \
        --nodejs-${nodeVersion}
      '';
      # the shell attribute has the nodeDependencies, whereas the package does not
      node2nixShell = (import node2nixDrv { inherit pkgs nodejs; }).shell.overrideAttrs (attrs: {
        buildInputs = attrs.buildInputs ++ [ nodePackages.node-gyp-build ];
        dontNpmInstall = true;
      });
      node2nixProd = node2nixShell.nodeDependencies.overrideAttrs (o: {
        dontNpmInstall = true;
      });
    };

in
{
  myNodePackages = (prev.callPackage ifd { }).node2nixProd;
  inherit node2nix;
}
