return {
  "tyru/open-browser.vim",
  config = function()
    require("configs.utils").map("n", "gx", "<Plug>(openbrowser-smart-search)")
  end
}
