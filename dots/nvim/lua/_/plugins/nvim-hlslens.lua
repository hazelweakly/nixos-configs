require("hlslens").setup({
  calm_down = true,
  nearest_only = true,
  virt_priority = 10,
})

local map = require("configs.utils").map
local t = function(keys)
  return function()
    vim.api.nvim_feedkeys(keys, "n", true)
    require("hlslens").start()
  end
end

map("n", "n", t(vim.v.count1 .. "n"))
map("n", "N", t(vim.v.count1 .. "N"))

map({ "n", "x" }, "*", t("*"))
map({ "n", "x" }, "#", t("#"))
map({ "n", "x" }, "g*", t("g*"))
map({ "n", "x" }, "g#", t("g#"))
