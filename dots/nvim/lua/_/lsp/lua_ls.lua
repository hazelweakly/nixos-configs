return {
  settings = {
    Lua = {
      semantic = { enable = false },
      completion = { keywordSnippet = "Replace", autoRequire = false },
      diagnostics = { globals = { "vim" } },
      format = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
  before_init = require("neodev.lsp").before_init,
  -- force_setup = true,
}
