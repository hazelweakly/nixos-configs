final: prev: rec {
  tree-sitter-grammars =
    let
      fetchGrammar = (v: prev.fetchgit { inherit (v) url rev sha256 fetchSubmodules; });
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
  vimPlugins = prev.vimPlugins // {
    nvim-treesitter = prev.vimPlugins.nvim-treesitter // {
      builtGrammars = prev.vimPlugins.nvim-treesitter.builtGrammars // {
        inherit (tree-sitter-grammars) tree-sitter-just tree-sitter-dhall;
      };
      allGrammars = prev.vimPlugins.nvim-treesitter.allGrammars ++ [ tree-sitter-grammars.tree-sitter-just tree-sitter-grammars.tree-sitter-dhall ];
    };
  };
}
