final: prev:
let
  dateFrom = d: builtins.substring 0 4 d + "-" + builtins.substring 4 2 d + "-" + builtins.substring 6 2 d;
  date = dateFrom final.inputs.treesitter.lastModifiedDate;
  nvim-ts = prev.vimPlugins.nvim-treesitter.overrideAttrs (o: {
    name = "vimplugin-nvim-treesitter-${date}";
    version = date;
    src = final.inputs.treesitter;
    postInstall = (o.postInstall or "") + ''
      ln -s ${justSrc.path}/queries/just $out/queries/just
    '';
  });

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
  toBuild = {
    tree-sitter-just = justSrc;
  };
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
    in
    prev.tree-sitter-grammars // (prev.lib.mapAttrs change toBuild);
  tree-sitter = prev.tree-sitter // {
    builtGrammars = prev.tree-sitter.builtGrammars // {
      inherit (tree-sitter-grammars) tree-sitter-just;
    };
    allGrammars = prev.tree-sitter.allGrammars ++ [ tree-sitter-grammars.tree-sitter-just ];
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
          inherit (tree-sitter-grammars) tree-sitter-just;
        };
        withPlugins = f: nvim-ts.overrideAttrs (_: {
          passthru.dependencies = map grammarToPlugin allGrammars;
        });
        allGrammars = nvim-ts.allGrammars ++ [ tree-sitter-grammars.tree-sitter-just ];
        passthru.dependencies = map grammarToPlugin allGrammars;
      };
    };
}
