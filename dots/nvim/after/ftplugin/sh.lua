vim.opt.iskeyword:append("-")
require("configs.utils").ftplugin.undo("setl iskeyword<")
vim.lsp.enable("bashls")
