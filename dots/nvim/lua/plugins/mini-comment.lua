return {
  "echasnovski/mini.comment",
  enabled = false,
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  keys = { { "gc", mode = { "n", "v" } } },
  opts = {
    hooks = {
      pre = function()
        require("ts_context_commentstring.internal").update_commentstring({})
      end,
    },
  },
}
