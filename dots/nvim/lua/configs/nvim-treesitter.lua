-- require("nvim-treesitter.install").compilers = { "clang", "gcc", "cc" }
require("nvim-treesitter.install").compilers = { "zig" }

-- ugly hack to "add" zsh: https://github.com/nvim-treesitter/nvim-treesitter/issues/655
local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang
require("nvim-treesitter.parsers").ft_to_lang = function(ft)
  if ft == "zsh" then
    return "bash"
  end
  return ft_to_lang(ft)
end

require("tree-sitter-just").setup({})

require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
  ignore_install = { "swift" },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },
  rainbow = { enable = true, extended_mode = true },
  autotag = { enable = true },
  autopairs = { enable = true },
  textobjects = {
    select = {
      enable = true,
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
      swap_next = {
        ["g>"] = "@parameter.inner",
      },
      swap_previous = {
        ["g<"] = "@parameter.inner",
      },
    },
    lsp_interop = {
      enable = true,
      border = require("configs.utils").border,
      peek_definition_code = {
        ["gD"] = "@function.outer",
        ["<leader>gd"] = "@class.outer",
      },
    },
  },
  refactor = { highlight_definitions = { enable = true } },
  textsubjects = {
    enable = true,
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
    },
  },
})
