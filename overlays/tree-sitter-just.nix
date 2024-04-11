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
{
  tree-sitter = prev.tree-sitter // {
    builtGrammars = prev.tree-sitter.builtGrammars;
    allGrammars = prev.tree-sitter.allGrammars;
  };
  vimPlugins = prev.vimPlugins // {
    nvim-treesitter = nvim-ts // rec {
      builtGrammars = nvim-ts.builtGrammars;
      withPlugins = f: nvim-ts.overrideAttrs (_: {
        passthru.dependencies = map prev.neovimUtils.grammarToPlugin allGrammars;
      });
      withAllGrammars = withPlugins (_: allGrammars);
      allGrammars = nvim-ts.allGrammars;
      passthru.dependencies = map prev.neovimUtils.grammarToPlugin allGrammars;
    };
  };
}
