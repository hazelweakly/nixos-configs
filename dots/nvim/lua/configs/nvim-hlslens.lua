require("hlslens").setup({
  calm_down = true,
  nearest_only = true,
  virt_priority = 10,
})

local map = require("configs.utils").map

map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])

map({ "n", "x" }, "*", [[*<Cmd>lua require('hlslens').start()<CR>]])
map({ "n", "x" }, "#", [[#<Cmd>lua require('hlslens').start()<CR>]])
map({ "n", "x" }, "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]])
map({ "n", "x" }, "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]])
