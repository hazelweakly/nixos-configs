local M = {}

M.on_attach = function(client, bufnr)
  if client.supports_method("textDocument/rangeFormatting") then
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  end

  local utils = require("configs.utils")
  require("lsp_signature").on_attach({
    bind = true,
    max_height = 4,
    transparency = 30,
    zindex = 50,
    always_trigger = true,
    timer_interval = 100,
    handler_opts = { border = utils.border },
  }, bufnr)

  if client.supports_method("textDocument/codeAction") then
    utils.buf_map(bufnr, "n", "ga", vim.lsp.buf.code_action)
  end
  if client.supports_method("textDocument/declaration") then
    utils.buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration)
  end
  if client.supports_method("textDocument/definition") then
    utils.buf_map(bufnr, "n", "gd", function()
      return require("telescope.builtin").lsp_definitions()
    end)
  end
  if client.supports_method("textDocument/hover") then
    utils.buf_map(bufnr, "n", "K", vim.lsp.buf.hover)
  end
  if client.supports_method("textDocument/signatureHelp") then
    utils.buf_map(bufnr, "n", "gk", vim.lsp.buf.signature_help)
  end
  if client.supports_method("textDocument/rename") then
    utils.buf_map(bufnr, "n", "gr", vim.lsp.buf.rename)
  end
  if client.supports_method("textDocument/references") then
    utils.buf_map(bufnr, "n", "gR", function()
      return require("telescope.builtin").lsp_references()
    end)
  end
  utils.buf_map(bufnr, "n", "<leader>e", function()
    return require("telescope.builtin").diagnostics({ bufnr = bufnr })
  end)
  utils.buf_map(bufnr, "n", "<C-p>", vim.diagnostic.goto_prev)
  utils.buf_map(bufnr, "n", "<C-n>", vim.diagnostic.goto_next)

  if client.supports_method("textDocument/formatting") then
    vim.cmd(string.format(
      [[
      if !exists('#LspFormatting%d#BufWritePre')
        augroup LspFormatting%d
          autocmd! * <buffer>
          autocmd BufWritePre <buffer=%d> lua vim.lsp.buf.formatting_seq_sync()
        augroup END
      endif
    ]],
      bufnr,
      bufnr,
      bufnr
    ))
  end
end

M.default_opts = function()
  local utils = require("configs.utils")
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

M.start_or_restart = function()
  if vim.b.direnv_lsp_loaded ~= nil then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local util = require("lspconfig").util
  for _, client in ipairs(util.get_managed_clients()) do
    if util.get_active_client_by_name(bufnr, client.name) ~= nil then
      client.stop()
    end
  end
  local buffer_filetype = vim.bo.filetype
  for _, config in pairs(require("lspconfig.configs")) do
    for _, filetype_match in ipairs(config.filetypes or {}) do
      if buffer_filetype == filetype_match then
        vim.defer_fn(config.launch, 500)
      end
    end
  end
  vim.b.direnv_lsp_loaded = true
end

return M
