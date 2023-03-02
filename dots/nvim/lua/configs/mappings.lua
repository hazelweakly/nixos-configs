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

map({ "n", "i", "s" }, "<c-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { expr = true })

map({ "n", "i", "s" }, "<c-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-b>"
  end
end, { expr = true })
