return {
  "Pocco81/HighStr.nvim",
  cmd = { "HSHighlight", "HSRmHighlight", "HSImport", "HSExport" },
  config = function()
    local high_str = require("high-str")
    local colors = require("configs.colors").get().colors

    high_str.setup({
      verbosity = 0,
      highlight_colors = {
        color_0 = { colors.blue, "smart" },
        color_1 = { colors.green2, "smart" },
        color_2 = { colors.blue6, "smart" },
        color_3 = { colors.magenta2, "smart" },
        color_4 = { colors.purple, "smart" },
        color_5 = { colors.orange, "smart" },
        color_6 = { colors.blue2, "smart" },
        color_7 = { colors.red, "smart" },
        color_8 = { colors.green, "smart" },
        color_9 = { colors.yellow, "smart" },
      },
    })
  end,
  init = function()
    local map = require("configs.utils").map
    for i = 0, 9, 1 do
      map("v", "<Leader>h" .. i, ":<c-u>HSHighlight " .. i .. "<CR>")
    end
    map("v", "<Leader>hc", ":<c-u>HSRmHighlight<CR>")
  end,
}
