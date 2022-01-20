return {
  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")
    require("_.lsp").on_attach(client, bufnr)
    -- format with null-ls and prettier, not tsserver
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    ts_utils.setup({
      enable_import_on_completion = true,
      update_imports_on_move = true,
    })
    ts_utils.setup_client(client)
  end,
  init_options = require("nvim-lsp-ts-utils").init_options,
  settings = { completions = { completeFunctionCalls = true } },
}
