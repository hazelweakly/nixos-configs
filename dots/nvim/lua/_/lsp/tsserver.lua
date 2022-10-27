local inlayHints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

return {
  on_init = function(client, _)
    client.notify("workspace/didChangeConfiguration", {
      settings = {
        completions = { completeFunctionCalls = true },
        typescript = { inlayHints = inlayHints },
        javascript = { inlayHints = inlayHints },
      },
    })
  end,
}
