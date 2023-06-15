return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", "<Plug>(dial-increment)" },
    { "<C-x>", "<Plug>(dial-decrement)" },
    { "<C-a>", "<Plug>(dial-increment)", mode = "v" },
    { "<C-x>", "<Plug>(dial-decrement)", mode = "v" },
    { "g<C-a>", "<Plug>(dial-increment)", mode = "v" },
    { "g<C-x>", "<Plug>(dial-decrement)", mode = "v" },
  },
}
