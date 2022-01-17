return {
  on_attach = function(client, bufnr)
    require("_.lsp").on_attach(client, bufnr)
    -- format with null-ls and prettier, not jsonls
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end,
  settings = {
    json = { schemas = require("schemastore").json.schemas() },
  },
}
