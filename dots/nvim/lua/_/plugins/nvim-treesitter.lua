-- ugly hack to "add" zsh: https://github.com/nvim-treesitter/nvim-treesitter/issues/655
local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang
require("nvim-treesitter.parsers").ft_to_lang = function(ft)
  if ft == "zsh" then
    return "bash"
  end
  return ft_to_lang(ft)
end

require("tree-sitter-just").setup({})

local disable_if_large = function(_, bufnr)
  return require("_.large_file").is_large_file(bufnr)
end

require("nvim-treesitter.configs").setup({
  highlight = { enable = true, disable = disable_if_large },
  indent = { enable = true, disable = disable_if_large },
  ignore_install = { "swift" },
  context_commentstring = {
    enable = true,
    disable = disable_if_large,
    enable_autocmd = false,
  },
  incremental_selection = {
    enable = true,
    disable = disable_if_large,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },
  rainbow = { enable = true, disable = disable_if_large, extended_mode = true },
  autotag = { enable = true, disable = disable_if_large },
  autopairs = { enable = true, disable = disable_if_large },
  textobjects = {
    select = {
      enable = true,
      disable = disable_if_large,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      },
    },
    swap = {
      enable = true,
      disable = disable_if_large,
      swap_next = {
        ["g>"] = "@parameter.inner",
      },
      swap_previous = {
        ["g<"] = "@parameter.inner",
      },
    },
    lsp_interop = {
      enable = true,
      disable = disable_if_large,
      border = require("configs.utils").border,
      peek_definition_code = {
        ["gD"] = "@function.outer",
        ["<leader>gd"] = "@class.outer",
      },
    },
  },
  refactor = { highlight_definitions = { enable = true, disable = disable_if_large } },
  textsubjects = {
    enable = true,
    disable = disable_if_large,
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
    },
  },
})
