-- TODO: Replace with:
-- - https://github.com/mfussenegger/nvim-lint
-- - https://github.com/stevearc/conform.nvim
-- - https://github.com/lewis6991/hover.nvim
return {
  "nvimtools/none-ls.nvim",
  -- https://github.com/nvimtools/none-ls.nvim/issues/276
  build = {
    [[perl -pi -e "s/$/ or lsp.protocol._request_name_to_server_capability/ if $. == 78" ./lua/null-ls/client.lua ]],
    [[git update-index --assume-unchanged ./lua/null-ls/client.lua ]],
  },
  lazy = true,
  opts = function()
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    local null_ls = require("null-ls")
    return {
      debounce = 250,
      sources = {
        -- null_ls.builtins.code_actions.shellcheck,

        -- null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.actionlint,

        null_ls.builtins.formatting.shfmt.with({
          extra_args = function(params)
            ---@diagnostic disable-next-line: redundant-parameter
            return { "-s", "-i", vim.api.nvim_get_option_value("shiftwidth", { buf = params.bufnr }) }
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
