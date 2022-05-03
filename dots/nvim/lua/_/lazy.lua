return function()
  vim.defer_fn(function()
    local ldr = require("packer").loader
    ldr("nvim-web-devicons")
    ldr("nvim-treesitter")
    ldr(
      "nvim-ts-rainbow nvim-treesitter-refactor nvim-treesitter-textsubjects nvim-ts-autotag nvim-treehopper vim-matchup"
    )
    ldr("bufferline.nvim")
    ldr("indent-blankline.nvim")
  end, 10)
  vim.defer_fn(function()
    local ldr = require("packer").loader
    ldr("targets.vim")
    ldr("telescope.nvim")
    ldr("dressing.nvim")
    ldr("vim-repeat")
    ldr("bullets.vim")
  end, 20)
  vim.defer_fn(function()
    local ldr = require("packer").loader
    ldr("gitsigns.nvim")
    ldr("git-conflict.nvim")
    ldr("conjure")
    ldr("nvim-hlslens")
    ldr("vim-sandwich")
    ldr("vimtex")
    ldr("nvim-colorizer.lua")
    ldr("neogen")
  end, 40)
end
