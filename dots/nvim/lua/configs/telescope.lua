local M = {}
M.config = function()
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
end

M.mappings = function()
  local map = require("configs.utils").map
  map("n", "<leader><space>", function()
    return require("telescope.builtin").live_grep()
  end)
  map("n", "<leader>f", function()
    return require("telescope.builtin").find_files()
  end)
  map("n", "<leader>b", function()
    return require("telescope.builtin").buffers()
  end)
end

return M
