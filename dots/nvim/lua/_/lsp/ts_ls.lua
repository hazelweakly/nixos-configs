return function(opts)
  require("typescript-tools").setup(require("configs.utils").merge(opts, {
    settings = {}, -- typescript-tools specific settings here
  }))
end
-- local inlayHints = {
--   includeInlayParameterNameHints = "all",
--   includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--   includeInlayFunctionParameterTypeHints = true,
--   includeInlayVariableTypeHints = true,
--   includeInlayPropertyDeclarationTypeHints = true,
--   includeInlayFunctionLikeReturnTypeHints = true,
--   includeInlayEnumMemberValueHints = true,
-- }

-- return {
--   on_init = function(client, _)
--     client.notify("workspace/didChangeConfiguration", {
--       settings = {
--         completions = { completeFunctionCalls = true },
--         -- Re-enable when typescript 5.4 is out
--         -- typescript = { inlayHints = inlayHints },
--         -- javascript = { inlayHints = inlayHints },
--       },
--     })
--   end,
-- }
