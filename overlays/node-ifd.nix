final: prev:

let
  ifd =
    { runCommandNoCC
    , nodejs
    , nodePackages
    , pkgs
    , lib
    }:

    let src_tree = ../nodePackages; in

    rec {
      nodeVersion = builtins.elemAt (lib.versions.splitVersion nodejs.version) 0;
      node2nixDrv = runCommandNoCC "node2nix" { } ''
        mkdir $out
        ${nodePackages.node2nix}/bin/node2nix \
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
  prettierme = prev.writeShellScriptBin "prettierme" ''
    [ ! -f ~/.prettierd ] && { prettierd start && sleep 0.1; }
    read -r prettierdport prettierdtoken <~/.prettierd
    output = $(nc 127.0.0.1 "$prettierdport" < <(printf '%s\n%s' "$prettierdtoken $PWD $1" "$(</dev/stdin)"))
    [[ ''${output##*$'\n'} != "# exit 1" ]] && echo "$output"
    :
  '';
}
