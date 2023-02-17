vim.b.did_sandwich_nix_ftplugin = 1
vim.cmd([[
if exists("sandwich#util#addlocal")
  call sandwich#util#addlocal([
    \ { 'buns': ["''", "''"], 'input': ['q'], 'cursor': 'keep' },
    \ { 'buns': ["''","''"],  'input': ['Q'], 'linewise': 1, 'cursor': 'keep' },
    \ { 'buns': ['${','}'],  'input': ['$'] },
    \ ])
endif
]])

require("configs.utils").ftplugin.undo({
  "unlet b:did_sandwich_nix_ftplugin",
  [[if exists("sandwich#util#ftrevert") | call sandwich#util#ftrevert("nix") | endif]],
})

vim.bo.commentstring = "# %s"

-- TODO: figure this out later
-- {'buns': ['\(^\s*\)\?' . "\'\'" . '\(\s*$\)', '\(^\s*\)' . "\'\'" . '\(\s*$\)\?'], 'regex': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['q'], 'cursor': 'keep'},
