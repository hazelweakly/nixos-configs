vim.opt.iskeyword:append("-")
vim.b.did_sandwich_sh_ftplugin = 1

vim.cmd([[if exists("sandwich#util#addlocal") | call sandwich#util#addlocal([{ 'buns': ['${','}'],  'input': ['$'] }]) | endif]])

require("configs.utils").ftplugin.undo({
  "setl iskeyword<",
  "unlet! b:did_sandwich_sh_ftplugin",
  [[if exists("sandwich#util#ftrevert") | call sandwich#util#ftrevert("sh") | endif]],
})
