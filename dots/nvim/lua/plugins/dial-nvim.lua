return {
  "monaqa/dial.nvim",
  keys = {
    "<C-a>",
    "<C-x>",
    { "<C-a>", mode = "v" },
    { "<C-x>", mode = "v" },
    { "g<C-a>", mode = "v" },
    { "g<C-x>", mode = "v" },
  },
  init = function()
    local map = require("configs.utils").map
    map("n", "<C-a>", function()
      require("dial.map").inc_normal()
    end)
    map("n", "<C-x>", function()
      require("dial.map").dec_normal()
    end)
    map("v", "<C-a>", function()
      require("dial.map").inc_visual()
    end)
    map("v", "<C-x>", function()
      require("dial.map").dec_visual()
    end)
    map("v", "g<C-a>", function()
      require("dial.map").inc_gvisual()
    end)
    map("v", "g<C-x>", function()
      require("dial.map").dec_gvisual()
    end)
  end
}
