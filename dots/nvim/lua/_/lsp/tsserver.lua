return {
  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.disable_inlay_hints(bufnr)
    require("_.lsp").on_attach(client, bufnr)
    ts_utils.setup({
      enable_import_on_completion = true,
      update_imports_on_move = true,
    })
    ts_utils.setup_client(client)
    ts_utils.inlay_hints(bufnr)
  end,
  init_options = require("nvim-lsp-ts-utils").init_options,
  settings = { completions = { completeFunctionCalls = true } },
}
