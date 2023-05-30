return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    local null_ls = require("null-ls")
    return {
      debounce = 250,
      sources = {
        null_ls.builtins.code_actions.shellcheck,

        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.actionlint,

        null_ls.builtins.formatting.shfmt.with({
          extra_args = function(params)
            ---@diagnostic disable-next-line: redundant-parameter
            return { "-s", "-i", vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth") }
          end,
        }),
        -- null_ls.builtins.formatting.prettier_d_slim, -- breaks formatexpr for gq
        null_ls.builtins.formatting.prettier, -- breaks formatexpr for gq
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
      },
      update_on_insert = false, -- some language servers really hate this
    }
  end,
}
