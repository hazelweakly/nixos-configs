local telescope = require("telescope")
telescope.setup({
  defaults = {
    initial_mode = "insert",
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
      "--iglob",
      "!.git",
      "--hidden",
    },
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<esc>"] = require("telescope.actions").close,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", "/.git/" },
    },
  },
})
telescope.load_extension("fzf")
