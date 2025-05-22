-- TODO: https://github.com/wader/jq-lsp ??
-- https://github.com/msvechla/yaml-companion.nvim/tree/kubernetes_crd_detection ??
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#textlsp
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#typos_lsp
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#typst_lsp if I rewrite my resume in typst
return {
  "neovim/nvim-lspconfig",
  -- lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lspconfig = require("lspconfig")
    local merge = require("configs.utils").merge
    pcall(require, "null-ls")

    -- TODO: at some point I want to make it so I can truly lazy load these
    -- but currently even setting them up often invokes requiring all the dependencies
    -- which might be heavyweight and adds a *lot* of startup time
    local servers = {
      "basedpyright",
      "bashls",
      "cssls",
      "docker_compose_language_service",
      "dockerls",
      "eslint",
      "gopls",
      "helm_ls",
      "html",
      "jsonls",
      "lua_ls",
      "nil_ls",
      "terraformls",
      "yamlls",
    }

    for _, s in pairs(servers) do
      local has, s_opts = pcall(require, "_.lsp." .. s)
      if has then
        if type(s_opts) == "function" then
          s_opts(lspconfig[s] or {})
        else
          vim.lsp.config(s, s_opts)
          vim.lsp.enable(s)
        end
      else
        vim.lsp.enable(s)
      end
    end
  end,
}
