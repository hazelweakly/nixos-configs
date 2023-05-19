final: prev:
let
  nvim-ts = prev.vimPlugins.nvim-treesitter.overrideAttrs (o: {
    name = "vimplugin-nvim-treesitter-2023-05-19";
    version = "2023-05-19";
    src = prev.fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "dad1b7cd6606ffaa5c283ba73d707b4741a5f445";
      hash = "sha256-Xrk+fjG2/X4NfqAZ5G9G+MNoZAZ0ElDOoJagFv3jfP8=";
    };
  });
in
rec {
  tree-sitter-grammars =
    let
      fetchGrammar = (v: prev.fetchgit {
        inherit (v) url rev sha256 fetchSubmodules;
      });
      change = name: grammar:
        final.callPackage (prev.path + "/pkgs/development/tools/parsing/tree-sitter/grammar.nix") { } {
          language = if grammar ? language then grammar.language else name;
          inherit (final.tree-sitter) version;
          src = if grammar ? src then grammar.src else fetchGrammar grammar;
          location = if grammar ? location then grammar.location else null;
        };
      justSrc = builtins.fromJSON ''
        {
          "url": "https://github.com/IndianBoy42/tree-sitter-just",
          "rev": "8af0aab79854aaf25b620a52c39485849922f766",
          "date": "2021-11-02T20:53:27+08:00",
          "path": "/nix/store/pcpnqn0m64003ac8f3253s3wfji3yzzp-tree-sitter-just-8af0aab",
          "sha256": "15hl3dsr5kxjl1kl9md2gb9bwj0ni54d9k6jv1h74b3psf4qb0l5",
          "fetchLFS": false,
          "fetchSubmodules": false,
          "deepClone": false,
          "leaveDotGit": false
        }'';
      dhallSrc = builtins.fromJSON ''
        {
          "url": "https://github.com/jbellerb/tree-sitter-dhall",
          "rev": "affb6ee38d629c9296749767ab832d69bb0d9ea8",
          "date": "2022-06-26T01:12:29-04:00",
          "path": "/nix/store/f2ikmhfxpx1zpfg5wyw772arfjz6ph2z-tree-sitter-dhall-affb6ee",
          "sha256": "0r4f4w2jhm2hyvh3r3phdjhigsh0an8g4p21cbz8ldkld8ma9lxb",
          "fetchLFS": false,
          "fetchSubmodules": false,
          "deepClone": false,
          "leaveDotGit": false
        }
      '';
      toBuild = {
        tree-sitter-just = justSrc;
        tree-sitter-dhall = dhallSrc;
      };
    in
    prev.tree-sitter-grammars // (prev.lib.mapAttrs change toBuild);
  tree-sitter = prev.tree-sitter // {
    builtGrammars = prev.tree-sitter.builtGrammars // {
      inherit (tree-sitter-grammars) tree-sitter-just tree-sitter-dhall;
    };
    allGrammars = prev.tree-sitter.allGrammars ++ [ tree-sitter-grammars.tree-sitter-just tree-sitter-grammars.tree-sitter-dhall ];
  };
  vimPlugins =
    let
      grammarToPlugin = grammar:
        let
          name = prev.lib.pipe grammar [
            prev.lib.getName

            # added in buildGrammar
            (prev.lib.removeSuffix "-grammar")

            # grammars from tree-sitter.builtGrammars
            (prev.lib.removePrefix "tree-sitter-")
            (prev.lib.replaceStrings [ "-" ] [ "_" ])
          ];
        in
        prev.runCommand "nvim-treesitter-grammar-${name}" { } ''
          mkdir -p $out/parser
          ln -s ${grammar}/parser $out/parser/${name}.so
        '';
    in
    prev.vimPlugins // {
      nvim-treesitter = nvim-ts // rec {
        builtGrammars = nvim-ts.builtGrammars // {
          inherit (tree-sitter-grammars) tree-sitter-just tree-sitter-dhall;
        };
        withPlugins = f: nvim-ts.overrideAttrs (_: {
          passthru.dependencies = map grammarToPlugin allGrammars;
        });
        allGrammars = nvim-ts.allGrammars ++ [ tree-sitter-grammars.tree-sitter-just tree-sitter-grammars.tree-sitter-dhall ];
        passthru.dependencies = map grammarToPlugin allGrammars;
      };
    };
}
