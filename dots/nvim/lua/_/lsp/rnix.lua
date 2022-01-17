return {
  on_attach = function(client, bufnr)
    require("_.lsp").on_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end,
}
