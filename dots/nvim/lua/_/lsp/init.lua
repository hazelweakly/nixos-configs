local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.on_attach = function(client, bufnr)
  local utils = require("configs.utils")
  local buf_map = utils.buf_map
  require("lsp_signature").on_attach({
    bind = false,
    transparency = 50,
    zindex = 10,
    hint_enable = false,
    handler_opts = { border = utils.border },
  }, bufnr)

  buf_map(bufnr, "x", "<leader>la", vim.lsp.buf.range_code_action)
  if client.supports_method("textDocument/codeAction") then
    buf_map(bufnr, "n", "ga", vim.lsp.buf.code_action)
  end
  if client.supports_method("textDocument/declaration") then
    buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration)
  end
  if client.supports_method("textDocument/definition") then
    buf_map(bufnr, "n", "gd", function()
      return require("telescope.builtin").lsp_definitions()
    end)
  end
  if client.supports_method("textDocument/hover") then
    buf_map(bufnr, "n", "K", vim.lsp.buf.hover)
  end
  if client.supports_method("textDocument/signatureHelp") then
    buf_map(bufnr, "n", "gk", vim.lsp.buf.signature_help)
  end
  if client.supports_method("textDocument/rename") then
    buf_map(bufnr, "n", "gr", vim.lsp.buf.rename)
  end
  if client.supports_method("textDocument/references") then
    buf_map(bufnr, "n", "gR", function()
      return require("telescope.builtin").lsp_references()
    end)
  end
  buf_map(bufnr, "n", "<leader>e", function()
    return require("telescope.builtin").diagnostics({ bufnr = bufnr })
  end)
  buf_map(bufnr, "n", "<C-p>", vim.diagnostic.goto_prev)
  buf_map(bufnr, "n", "<C-n>", vim.diagnostic.goto_next)

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(c)
            -- filter out clients that you don't want to use
            return c.name ~= "tsserver" and c.name ~= "jsonls" and c.name ~= "rnix" and c.name ~= "sumneko_lua"
          end,
          bufnr = bufnr,
          timeout = 5000,
        })
      end,
    })
  end
end

M.default_opts = function()
  local utils = require("configs.utils")
  return {
    on_attach = M.on_attach,
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = { debounce_text_changes = 150 },
    handlers = {
      ["textDocument/signatureHelp"] = vim.lsp.with(
        require("lsp_signature").signature_handler,
        { border = utils.border }
      ),
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = utils.border }),
    },
  }
end

-- M.start_or_restart = function()
--   if vim.b.direnv_lsp_loaded ~= nil then
--     return
--   end
--
--   local bufnr = vim.api.nvim_get_current_buf()
--   local util = require("lspconfig").util
--   for _, client in ipairs(util.get_managed_clients()) do
--     if util.get_active_client_by_name(bufnr, client.name) ~= nil then
--       client.stop()
--     end
--   end
--   local buffer_filetype = vim.bo.filetype
--   for _, config in pairs(require("lspconfig.configs")) do
--     for _, filetype_match in ipairs(config.filetypes or {}) do
--       if buffer_filetype == filetype_match then
--         vim.defer_fn(config.launch, 50)
--       end
--     end
--   end
--   vim.b.direnv_lsp_loaded = true
-- end

return M
