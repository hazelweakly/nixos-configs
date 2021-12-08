require("impatient")

local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "python_provider",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

require("configs.options")
require("configs.mappings")

require("packer_compiled")
require("configs.settings")
require("configs.filetype_settings")
require("configs.colors")

vim.cmd([[
augroup vimrc
    au!
    autocmd CursorHold * ++once lua require('plugins')
augroup END

function! Requirements_matched_filename(arg)
    return v:true
endfunction
]])

-- " https://learnvimscriptthehardway.stevelosh.com/chapters/42.html
-- " https://github.com/22mahmoud/neovim
-- " https://github.com/nanotee/nvim-lua-guide/
--
-- " configs:
-- " - https://old.reddit.com/r/neovim/comments/r0a33t/good_neovim_configurations/
-- " ecovim for reactJS: https://github.com/ecosse3/nvim
-- " lunarvim and nvchad / gigachad
-- " https://github.com/jdhao/nvim-config/
--
-- " https://github.com/phaazon/hop.nvim
-- " lightspeed.nvim
-- " renamer.nvim
-- " ldelossa/calltree.nvim
-- " neovim-cmp ?
-- " fine-cmdline.nvim
-- " telescope
-- " cokeline.nvim ?
-- " searchbox.nvim ?
-- " dressing.nvim
-- " lazy load packer stuff.
-- " evaluate packer vs paq vs...?
-- " mini.nvim ?
