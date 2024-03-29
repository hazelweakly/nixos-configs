return {
  settings = {
    Lua = {
      semantic = { enable = true },
      hint = { enable = true },
      completion = { keywordSnippet = "Replace", autoRequire = false },
      diagnostics = { globals = { "vim" } },
      format = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
  before_init = function(...)
    return require("neodev.lsp").before_init(...)
  end,
}
