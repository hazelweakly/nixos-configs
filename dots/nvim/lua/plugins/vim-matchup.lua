return {
  "andymass/vim-matchup",
  opts = {},
  init = function()
    vim.g.matchup_treesitter_disable_virtual_text = true
    vim.g.matchup_matchparen_enabled = 0
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_surround_enabled = 0
    vim.g.matchup_motion_override_Npercent = 0
    vim.g.matchup_matchparen_offscreen = {}
    vim.g.matchup_delim_noskips = 2
  end,
}
