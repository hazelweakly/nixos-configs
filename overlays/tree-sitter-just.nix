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
      src = builtins.fromJSON ''
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
      toBuild = {
        tree-sitter-just = src;
      };
    in
    prev.tree-sitter-grammars // (prev.lib.mapAttrs change toBuild);
  tree-sitter = prev.tree-sitter // {
    builtGrammars = prev.tree-sitter.builtGrammars // {
      inherit (tree-sitter-grammars) tree-sitter-just;
    };
    allGrammars = prev.tree-sitter.allGrammars ++ [ tree-sitter-grammars.tree-sitter-just ];
  };
  vimPlugins = prev.vimPlugins // {
    nvim-treesitter = prev.vimPlugins.nvim-treesitter // {
      builtGrammars = prev.vimPlugins.nvim-treesitter.builtGrammars // {
        inherit (tree-sitter-grammars) tree-sitter-just;
      };
      allGrammars = prev.vimPlugins.nvim-treesitter.allGrammars ++ [ tree-sitter-grammars.tree-sitter-just ];
    };
  };
}
