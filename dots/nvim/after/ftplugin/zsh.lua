vim.opt.iskeyword:append("-")
vim.b.did_sandwich_zsh_ftplugin = 1

vim.cmd([[call sandwich#util#addlocal([{ 'buns': ['${','}'],  'input': ['$'] }])]])

require("configs.utils").ftplugin.undo({
  "setl iskeyword<",
  "unlet b:did_sandwich_zsh_ftplugin",
  [[call sandwich#util#ftrevert("zsh")]],
})
