return {
  -- https://github.com/agorgl/yaml-companion.nvim/tree/patch-1
  -- https://github.com/someone-stole-my-name/yaml-companion.nvim/pull/50
  -- "someone-stole-my-name/yaml-companion.nvim",
  "agorgl/yaml-companion.nvim",
  branch = "patch-1",
  lazy = true,
  build = [[sed -i 's/get_active_clients/get_clients/' ./lua/yaml-companion/lsp/util.lua ;]],
  requires = {
    { "neovim/nvim-lspconfig" },
    { "nvim-lua/plenary.nvim" },
  },
}
