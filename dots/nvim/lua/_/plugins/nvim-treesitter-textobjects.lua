require("nvim-treesitter.configs").setup({
  textobjects = {
    select = {
      enable = true,
      disable = require("_.large_file").is_large_file,
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
      disable = require("_.large_file").is_large_file,
      swap_next = {
        ["g>"] = "@parameter.inner",
      },
      swap_previous = {
        ["g<"] = "@parameter.inner",
      },
    },
    lsp_interop = {
      enable = true,
      disable = require("_.large_file").is_large_file,
      border = require("configs.utils").border,
      peek_definition_code = {
        ["gD"] = "@function.outer",
        ["<leader>gd"] = "@class.outer",
      },
    },
  },
})
