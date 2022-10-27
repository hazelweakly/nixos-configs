return function(opts)
  require("rust-tools").setup({
    tools = {
      hover_actions = { border = require("configs.utils").border },
      inlay_hints = { auto = false },
    },
    server = require("configs.utils").merge(opts, {
      root_dir = require("lspconfig.util").root_pattern("Cargo.toml"),
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = { command = "clippy" },
          cargo = { loadOutDirsFromCheck = true },
          procMacro = { enable = true },
        },
      },
    }),
  })
end
