return {
  "knubie/vim-kitty-navigator",
  build = "cp ./*.py ~/.config/kitty/",
  keys = {
    "<M-h>",
    "<M-j>",
    "<M-k>",
    "<M-l>",
  },
  config = function()
    local map = require("configs.utils").map
    map("n", "<M-h>", ":KittyNavigateLeft<cr>")
    map("n", "<M-j>", ":KittyNavigateDown<cr>")
    map("n", "<M-k>", ":KittyNavigateUp<cr>")
    map("n", "<M-l>", ":KittyNavigateRight<cr>")
  end,
  init = function()
    vim.g.kitty_navigator_no_mappings = 1
  end,
}
