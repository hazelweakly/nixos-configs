return {
  "andymass/vim-matchup",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter", lazy = "true" },
  config = function()
    vim.defer_fn(function()
      require("nvim-treesitter.configs").setup({
        matchup = { enable = true, disable_virtual_text = true },
      })
    end, 0)
  end,
  init = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_surround_enabled = 0
    vim.g.matchup_motion_override_Npercent = 0
    vim.g.matchup_matchparen_offscreen = {}
    vim.g.matchup_delim_noskips = 2
  end,
}
