local map = require("configs.utils").map
map("n", "<C-a>", "<Plug>(dial-increment)")
map("n", "<C-x>", "<Plug>(dial-decrement)")
map("v", "<C-a>", "<Plug>(dial-increment)")
map("v", "<C-x>", "<Plug>(dial-decrement)")
map("v", "g<C-a>", "<Plug>(dial-increment-additional)")
map("v", "g<C-x>", "<Plug>(dial-decrement-additional)")
