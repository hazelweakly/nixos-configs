return require("lua-dev").setup({
  runtime_path = true,
  lspconfig = {
    settings = {
      Lua = {
        completion = { keywordSnippet = "Replace", autoRequire = false },
        color = { mode = "SemanticEnhanced" },
        hint = { enable = true },
        diagnostics = { globals = { "vim" } },
        workspace = { maxPreload = 10000, preloadFileSize = 100000 },
      },
    },
  },
})
