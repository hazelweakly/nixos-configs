require("mason-lspconfig").setup({
  automatic_installation = { exclude = { "hls", "rnix", "taplo", "rust_analyzer", "ltex", "gopls" } },
})
-- require("lspconfig.configs").ls_emmet = { default_config = {} }
local lsp = require("_.lsp")
local merge = require("configs.utils").merge
local lspconfig = require("lspconfig")
lspconfig.util.default_config = merge(lspconfig.util.default_config, lsp.default_opts())

local servers = {
  -- "ansiblels",
  "bashls",
  "clojure_lsp",
  "cssls",
  "dockerls",
  "eslint",
  "gopls",
  "hls",
  "html",
  "jsonls",
  -- "ls_emmet",
  -- "ltex",
  "pyright",
  "rnix",
  "rust_analyzer",
  "sumneko_lua",
  "tailwindcss",
  -- "taplo",
  "terraformls",
  -- "texlab",
  -- "tflint",
  "tsserver",
  "vimls",
  "yamlls",
  "zk",
}

for _, s in pairs(servers) do
  local has, s_opts = pcall(require, "_.lsp." .. s)
  if not has then
    s_opts = {}
  end

  if type(s_opts) == "function" then
    s_opts(lspconfig.util.default_config)
  else
    lspconfig[s].setup(s_opts)
  end
end

vim.diagnostic.config({
  severity_sort = true,
  float = { border = require("configs.utils").border },
  virtual_text = false,
  update_in_insert = false,
  signs = true,
  underline = false,
})

for type, icon in pairs({ Error = " ", Warn = " ", Hint = " ", Info = " " }) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
