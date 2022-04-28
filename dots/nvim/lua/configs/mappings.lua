local map = require("configs.utils").map

map("n", "go", "<cmd>pu _<CR>:'[-1<CR>")
map("n", "gO", "<cmd>pu! _<CR>:']+1<CR>")

map("n", "<C-j>", "<cmd>m .+1<CR>==")
map("n", "<C-k>", "<cmd>m .-2<CR>==")
map("i", "<C-j>", "<Esc>:m .+1<CR>==gi")
map("i", "<C-k>", "<Esc>:m .-2<CR>==gi")
map("x", "<C-j>", ":m '>+1<CR>gv=gv")
map("x", "<C-k>", ":m '<-2<CR>gv=gv")

map("x", "<", "<gv")
map("x", ">", ">gv")

map("n", "<leader>,", ":")
map("x", "<leader>,", ":")

map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "q:", "<nop>")
map("", "<Space>", "<Nop>")

map("o", "m", [[:<C-U>lua require("tsht").nodes()<CR>]])
map("x", "m", [[:lua require("tsht").nodes()<CR>]])
