return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } }, lazy = true, lspconfig = false },
    { "b0o/schemastore.nvim", lazy = true },
  },
  config = function()
    local lsp_init = require("_.lsp")
    local lspconfig = require("lspconfig")
    local merge = require("configs.utils").merge
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      "bashls",
      "cssls",
      "dhall_lsp_server",
      "dockerls",
      "eslint",
      "gopls",
      "hls",
      "html",
      "jsonls",
      "lua_ls",
      "nil_ls",
      "pyright",
      "rust_analyzer",
      "terraformls",
      "tsserver",
      "yamlls",
    }

    for _, s in pairs(servers) do
      local has, s_opts = pcall(require, "_.lsp." .. s)
      if has then
        if type(s_opts) == "function" then
          s_opts(merge({
            on_attach = lsp_init.on_attach,
            capabilities = capabilities,
            flags = {
              allow_incremental_sync = true,
              debounce_text_changes = 250,
            },
          }, lspconfig[s] or {}))
        else
          lspconfig[s].setup(merge({
            on_attach = lsp_init.on_attach,
            capabilities = capabilities,
            flags = {
              allow_incremental_sync = true,
              debounce_text_changes = 250,
            },
          }, lspconfig[s] or {}, s_opts))
        end
      end
    end
  end,
}
