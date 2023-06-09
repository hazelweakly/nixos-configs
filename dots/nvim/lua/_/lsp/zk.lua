return function(opts)
  require("zk").setup({
    picker = "telescope",
    lsp = {
      config = require("configs.utils").merge(opts, {}),
    },
  })
end
