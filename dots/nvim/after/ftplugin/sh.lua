vim.opt.iskeyword:append("-")
vim.b.did_sandwich_sh_ftplugin = 1

vim.cmd([[call sandwich#util#addlocal([{ 'buns': ['${','}'],  'input': ['$'] }])]])

require("configs.utils").ftplugin.undo({
  "setl iskeyword<",
  "unlet b:did_sandwich_sh_ftplugin",
  [[call sandwich#util#ftrevert("sh")]],
})
