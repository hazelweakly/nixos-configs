local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local function is_null_ls_formatting_enabed(bufnr)
  local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if file_type == "markdown" then
    return false -- prettier breaks gq
  end
  local generators =
    require("null-ls.generators").get_available(file_type, require("null-ls.methods").internal.FORMATTING)
  return #generators > 0
end

M.on_attach = function(client, bufnr)
  local utils = require("configs.utils")
  local buf_map = utils.buf_map

  if client.server_capabilities.documentFormattingProvider then
    if client.name == "null-ls" and is_null_ls_formatting_enabed(bufnr) or client.name ~= "null-ls" then
      vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    else
      vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
    end
  end

  buf_map(bufnr, "x", "<leader>la", vim.lsp.buf.code_action)
  if client.server_capabilities.codeActionProvider then
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
  -- client.server_capabilities
  if client.server_capabilities.hoverProvider then
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

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(c)
            -- filter out clients that you don't want to use
            return c.name ~= "tsserver" and c.name ~= "jsonls" and c.name ~= "lua_ls"
          end,
          bufnr = bufnr,
          timeout = 5000,
        })
      end,
    })
  end

  require("lsp-inlayhints").on_attach(client, bufnr, false)
end

return M
