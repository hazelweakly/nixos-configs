return {
  "echasnovski/mini.align",
  keys = { { "<Leader>A", mode = "v" }, { "<Leader>a", mode = "v" } },
  config = function(_, opts)
    require("mini.align").setup(opts)
  end,
  opts = {
    mappings = {
      start = "<leader>A",
      start_with_preview = "<leader>a",
    },
  },
}
