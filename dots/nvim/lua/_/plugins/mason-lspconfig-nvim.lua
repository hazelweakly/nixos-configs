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

-- local function start_or_restart_lsp(bufnr)
--   if vim.fn.getbufvar(bufnr, "direnv_lsp_loaded", nil) ~= nil then
--     return
--   end
--
--   for _, client in ipairs(lspconfig.util.get_managed_clients()) do
--     if lspconfig.util.get_active_client_by_name(bufnr or 0, client.name) ~= nil then
--       client.stop()
--     end
--   end
--   for _, config in pairs(require("lspconfig.configs")) do
--     for _, filetype_match in ipairs(config.filetypes or {}) do
--       if vim.bo.filetype == filetype_match then
--         vim.defer_fn(config.launch, 125)
--       end
--     end
--   end
--
--   vim.fn.setbufvar(bufnr, "direnv_lsp_loaded", true)
-- end

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

-- -- This is here because this file is included and ran exactly once and is a stateful module.
-- vim.api.nvim_create_augroup("DirenvRestartServer", {})
-- vim.api.nvim_create_autocmd("User", {
--   group = "DirenvRestartServer",
--   pattern = "DirenvLoaded",
--   callback = function(args)
--     local bufnr = vim.api.nvim_get_current_buf()
--     start_or_restart_lsp(bufnr)
--   end,
-- })