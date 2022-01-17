vim.g.kitty_navigator_no_mappings = 1
vim.api.nvim_set_keymap("n", "<M-h>", ":KittyNavigateLeft<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<M-j>", ":KittyNavigateDown<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<M-k>", ":KittyNavigateUp<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<M-l>", ":KittyNavigateRight<cr>", { silent = true, noremap = true })
