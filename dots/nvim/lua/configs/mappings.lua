local map = require("configs.utils").map

map("n", "go", "<cmd>pu _<CR>:'[-1<CR>")
map("n", "gO", "<cmd>pu! _<CR>:']+1<CR>")

-- Replace cursor under word. Pressing . will move to next match and repeat
map("n", "c*", "/<<C-R>=expand('<cword>')<CR>>C<CR>``cgn")
map("n", "c#", "?<<C-R>=expand('<cword>')<CR>>C<CR>``cgN")

-- Delete cursor under word. Pressing . will move to next match and repeat
map("n", "d*", "/<<C-R>=expand('<cword>')<CR>>C<CR>``dgn")
map("n", "d#", "?<<C-R>=expand('<cword>')<CR>>C<CR>``dgN")

map("x", "<", "<gv")
map("x", ">", ">gv")

map("n", "<leader>,", ":")
map("x", "<leader>,", ":")

map("i", "<S-Tab>", "<C-d>")

map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")


