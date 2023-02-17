return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = true,
    use_treesitter = true,
  },
}
