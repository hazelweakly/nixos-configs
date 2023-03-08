return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim", "lsp-zero.nvim" },
  opts = function()
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    local null_ls = require("null-ls")
    local null_opts = require("lsp-zero").build_options("null-ls", {})

    return {
      debounce = 250,
      sources = {
        null_ls.builtins.code_actions.shellcheck,

        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.actionlint.with({
          runtime_condition = function(params)
            return string.match(params.bufname, ".*%.github/workflows/.*%.ya?ml") ~= nil
          end,
          extra_args = function(_)
            local path = require("null-ls.utils").path.join(".github", "actionlint.yaml")
            local has = require("null-ls.utils").make_conditional_utils().has_file(path)
            if has then
              return { "-config-file", path }
            else
              return false
            end
          end,
        }),

        null_ls.builtins.formatting.shfmt.with({
          extra_args = function(params)
            return { "-s", "-i", vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth") }
          end,
        }),
        null_ls.builtins.formatting.prettierd, -- breaks formatexpr for gq
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
      },
      update_on_insert = false, -- some language servers really hate this
      on_attach = function(client, bufnr)
        return null_opts.on_attach(client, bufnr)
      end,
    }
  end,
}
