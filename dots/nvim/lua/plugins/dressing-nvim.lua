return {
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
  config = function()
    require("dressing").setup({
      builtin = { border = require("configs.utils").border },
      input = { border = require("configs.utils").border },
      select = { telescope = require("telescope.themes").get_cursor({}) },
    })
  end,
}
