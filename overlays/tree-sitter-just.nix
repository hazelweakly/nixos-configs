final: prev:
let
  dateFrom = d: builtins.substring 0 4 d + "-" + builtins.substring 4 2 d + "-" + builtins.substring 6 2 d;
  date = dateFrom final.inputs.treesitter.lastModifiedDate;
  nvim-ts = prev.vimPlugins.nvim-treesitter.overrideAttrs (o: {
    name = "vimplugin-nvim-treesitter-${date}";
    version = date;
    src = final.inputs.treesitter;
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
          "rev": "43f2c5efb96e51bbd8e64284662911b60849df00",
          "date": "2024-03-04T13:46:59-06:00",
          "path": "/nix/store/5889r37baadhg4l0khc4yyyd392x09w4-tree-sitter-just",
          "sha256": "0kgivykyvc63vbjvn22x7dmwfy2c73hl1skkvfzyz3wfxnj5np4l",
          "hash": "sha256-lFxbpO2Oj++/23PqQOE4THjHaztdCLvl2sOw7aff8U0=",
          "fetchLFS": false,
          "fetchSubmodules": false,
          "deepClone": false,
          "leaveDotGit": false
        }
      '';
      dhallSrc = builtins.fromJSON ''
        {
          "url": "https://github.com/jbellerb/tree-sitter-dhall",
          "rev": "affb6ee38d629c9296749767ab832d69bb0d9ea8",
          "date": "2022-06-26T01:12:29-04:00",
          "path": "/nix/store/6l7g4d7v0zil6k1nl3a06iq1r65vw3v7-tree-sitter-dhall",
          "sha256": "0r4f4w2jhm2hyvh3r3phdjhigsh0an8g4p21cbz8ldkld8ma9lxb",
          "hash": "sha256-q9OkKmp0Nor+YkFc8pBVAOoXoWzwjjzg9lBUKAUnjmQ=",
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
