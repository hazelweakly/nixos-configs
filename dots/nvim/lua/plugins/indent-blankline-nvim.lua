return {
  "lukas-reineke/indent-blankline.nvim",
  event = "LspAttach",
  opts = {
    filetype_exclude = { "help", "alpha", "dashboard", "Trouble", "lazy", "notify" },
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = true,
  },
}
