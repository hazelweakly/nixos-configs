return {
  -- https://github.com/agorgl/yaml-companion.nvim/tree/patch-1
  -- https://github.com/someone-stole-my-name/yaml-companion.nvim/pull/50
  "mosheavni/yaml-companion.nvim",
  branch = "chore/remove-deprecated-apis",
  lazy = true,
  requires = {
    { "neovim/nvim-lspconfig" },
    { "nvim-lua/plenary.nvim" },
  },
}
