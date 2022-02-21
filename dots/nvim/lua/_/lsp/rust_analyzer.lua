return function(_, opts)
  local o = require("configs.utils").merge({ server = opts }, {
    tools = { hover_actions = { border = require("configs.utils").border } },
    server = {
      root_dir = require("lspconfig.util").root_pattern("Cargo.toml"),
    },
  })
  if o.server.cmd_env ~= nil and o.server.cmd_env.PATH ~= nil then
    o.server.cmd_env.PATH = nil
  end
  require("rust-tools").setup(o)

  return require("rust-tools.config").options.server
end
