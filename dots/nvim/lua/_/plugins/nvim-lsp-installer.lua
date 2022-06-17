require("nvim-lsp-installer").setup({
  automatic_installation = true,
  max_concurrent_installers = 10,
})

local servers = {
  "ansiblels",
  "bashls",
  "clojure_lsp",
  "cssls",
  "dockerls",
  "eslint",
  "gopls",
  "hls",
  "html",
  "jsonls",
  "ls_emmet",
  "ltex",
  "pyright",
  "rnix",
  "rust_analyzer",
  "sumneko_lua",
  "tailwindcss",
  "taplo",
  "terraformls",
  "texlab",
  "tflint",
  "tsserver",
  "vimls",
  "yamlls",
  "zk",
}

local lsp = require("_.lsp")
local merge = require("configs.utils").merge
local cfgs = require("lspconfig.configs")
local lspconfig = require("lspconfig")
for _, s in pairs(servers) do
  local has, s_opts = pcall(require, "_.lsp." .. s)
  if not has then
    s_opts = {}
  end
  if not cfgs[s] then
    cfgs[s] = { default_config = type(s_opts) == "function" and {} or s_opts }
  end

  if type(s_opts) == "function" then
    s_opts(lsp.default_opts())
  else
    lspconfig[s].setup(merge(lsp.default_opts(), s_opts))
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

-- This is here because this file is included and ran exactly once and is a stateful module.
vim.api.nvim_create_augroup("DirenvRestartServer", {})
vim.api.nvim_create_autocmd("User", {
  group = "DirenvRestartServer",
  pattern = "DirenvLoaded",
  callback = function()
    require("_.lsp").start_or_restart()
  end,
})
