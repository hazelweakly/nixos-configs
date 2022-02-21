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
    on_attach = function(client, bufnr)
      require("_.lsp").on_attach(client, bufnr)
      -- format with null-ls and stylua, not whatever sumneko_lua comes with
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end,
  },
})
