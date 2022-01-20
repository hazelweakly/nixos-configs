local M = {}
local utils = require("configs.utils")

M.on_attach = function(client, bufnr)
  if client.resolved_capabilities.document_range_formatting then
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

  if client.resolved_capabilities.code_action then
    utils.buf_map(bufnr, "n", "ga", vim.lsp.buf.code_action)
  end
  if client.resolved_capabilities.declaration then
    utils.buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration)
  end
  if client.resolved_capabilities.goto_definition then
    utils.buf_map(bufnr, "n", "gd", function()
      return require("telescope.builtin").lsp_definitions()
    end)
  end
  if client.resolved_capabilities.hover then
    utils.buf_map(bufnr, "n", "K", vim.lsp.buf.hover)
  end
  if client.resolved_capabilities.signature_help then
    utils.buf_map(bufnr, "n", "gk", vim.lsp.buf.signature_help)
  end
  if client.resolved_capabilities.rename then
    utils.buf_map(bufnr, "n", "gr", vim.lsp.buf.rename)
  end
  if client.resolved_capabilities.find_references then
    utils.buf_map(bufnr, "n", "gR", function()
      return require("telescope.builtin").lsp_references()
    end)
  end
  utils.buf_map(bufnr, "n", "<leader>e", function()
    return require("telescope.builtin").diagnostics({ bufnr = bufnr })
  end)
  utils.buf_map(bufnr, "n", "<C-p>", vim.diagnostic.goto_prev)
  utils.buf_map(bufnr, "n", "<C-n>", vim.diagnostic.goto_next)
end

M.default_opts = function()
  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = utils.border }),
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = { spacing = 5, severity_limit = "Warning" },
      update_in_insert = false,
    }),
  }

  return {
    on_attach = M.on_attach,
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
  zk = require("_.lsp.zk"),
  bashls = require("_.lsp.bashls"),
}

return M
