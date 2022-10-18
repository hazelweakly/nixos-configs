-- ugly hack to "add" zsh: https://github.com/nvim-treesitter/nvim-treesitter/issues/655
local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang
require("nvim-treesitter.parsers").ft_to_lang = function(ft)
  if ft == "zsh" then
    return "bash"
  end
  return ft_to_lang(ft)
end

-- builtin modules
require("nvim-treesitter.configs").setup({
  highlight = { enable = true, disable = require("_.large_file").is_large_file },
  auto_install = true,
  indent = { enable = true, disable = require("_.large_file").is_large_file },
  incremental_selection = {
    enable = true,
    disable = require("_.large_file").is_large_file,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },
})
