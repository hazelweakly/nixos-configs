return require("lua-dev").setup({
  lspconfig = {
    settings = {
      Lua = {
        semantic = { enable = false },
        completion = { keywordSnippet = "Replace", autoRequire = false },
        diagnostics = { globals = { "vim" } },
        format = { enable = false },
      },
    },
  },
})
