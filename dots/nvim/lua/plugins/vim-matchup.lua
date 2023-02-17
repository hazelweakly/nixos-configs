return {
  "andymass/vim-matchup",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      matchup = { enable = true, disable_virtual_text = true, disable = require("_.large_file").is_large_file },
    })
  end,
  init = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_surround_enabled = 0
    vim.g.matchup_motion_override_Npercent = 0
    vim.g.matchup_matchparen_offscreen = {}
    vim.g.matchup_delim_noskips = 2
  end,
}
