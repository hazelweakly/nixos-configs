require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  indent = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      scope_incremental = "<CR>",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
})
