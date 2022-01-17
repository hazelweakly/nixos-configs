-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local null_ls = require("null-ls")
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local FORMATTING = methods.internal.FORMATTING
local nixpkgs_fmt = h.make_builtin({
  name = "nixpkgs_fmt",
  method = FORMATTING,
  filetypes = { "nix" },
  generator_opts = {
    command = "nixpkgs-fmt",
    to_stdin = true,
  },
  factory = h.formatter_factory,
})
null_ls.register(nixpkgs_fmt)
null_ls.setup({
  debounce = 150,
  sources = {
    null_ls.builtins.code_actions.shellcheck,

    -- null_ls.builtins.diagnostics.codespell,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.hadolint,
    -- null_ls.builtins.diagnostics.statix,

    -- null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.shellharden,
    null_ls.builtins.formatting.black,
  },
  update_on_insert = true,
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      vim.cmd([[
        augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
        augroup END
      ]])
    end
  end,
})
