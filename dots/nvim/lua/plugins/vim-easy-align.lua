return {
  "echasnovski/mini.align",
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
