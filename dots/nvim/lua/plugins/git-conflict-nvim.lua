return {
  "akinsho/git-conflict.nvim",
  config = function(_, opts)
    require("git-conflict").setup(opts)
    vim.keymap.set("n", "gP", "<Plug>(git-conflict-prev-conflict)")
    vim.keymap.set("n", "gN", "<Plug>(git-conflict-next-conflict)")
  end,
  keys = { "gN", "gP" },
}
