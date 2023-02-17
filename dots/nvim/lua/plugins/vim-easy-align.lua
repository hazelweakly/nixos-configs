return {
  "junegunn/vim-easy-align",
  init = function()
    require("configs.utils").map("x", "<CR>", "<Plug>(EasyAlign)")
  end,
}
