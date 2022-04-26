return function(_, opts)
  local o = require("configs.utils").merge({ server = opts }, {
    tools = { hover_actions = { border = require("configs.utils").border } },
    server = {
      root_dir = require("lspconfig.util").root_pattern("Cargo.toml"),
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = { command = "clippy" },
          cargo = { loadOutDirsFromCheck = true },
          procMacro = { enable = true },
        },
      },
    },
  })
  require("rust-tools").setup(o)

  return require("rust-tools.config").options.server
end
