local M = {}
local utils = require("configs.utils")

M.on_attach = function(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  end

  require("lsp_signature").on_attach({
    bind = true,
    max_height = 4,
    transparency = 30,
    zindex = 50,
    always_trigger = true,
    timer_interval = 100,
    handler_opts = { border = utils.border },
  }, bufnr)

  local buf_map = utils.buf_map

  buf_map(bufnr, "n", "<leader>c", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_map(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  buf_map(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  buf_map(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  buf_map(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.rename()<CR>")
  buf_map(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.references()<CR>")
  buf_map(bufnr, "n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_map(bufnr, "n", "<leader>e", "<cmd>Telescope diagnostics bufnr=" .. bufnr .. "<CR>")
  buf_map(bufnr, "n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  buf_map(bufnr, "n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>")
  buf_map(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
end

M.default_opts = function()
  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = utils.border }),
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  return {
    on_attach = M.on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
    handlers = handlers,
  }
end

M.servers = {
  ansiblels = require("_.lsp.ansiblels"),
  jsonls = require("_.lsp.jsonls"),
  rnix = require("_.lsp.rnix"),
  sumneko_lua = require("_.lsp.sumneko_lua"),
  tailwindcss = require("_.lsp.tailwindcss"),
  tsserver = require("_.lsp.tsserver"),
  pyright = require("_.lsp.pyright"),
}

return M
