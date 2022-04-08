local map = require("configs.utils").map
for i = 0, 9, 1 do
  map("v", "<Leader>h" .. i, ":<c-u>HSHighlight " .. i .. "<CR>")
end
map("v", "<Leader>hc", ":<c-u>HSRmHighlight<CR>")
