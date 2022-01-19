local telescope = require("telescope")
telescope.setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
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
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
    },
  },
})
telescope.load_extension("fzf")

local map = require("configs.utils").map
map("n", "<leader><space>", [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
map("n", "<leader>f", [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
map("n", "<leader>b", [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
