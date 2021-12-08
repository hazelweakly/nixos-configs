require("indent_blankline").setup({
  show_current_context = true,
  show_current_context_start = true,
  show_end_of_line = true,
  use_treesitter = true,
})

__my_hacks = {}
__my_hacks.hl = function()
  local label_highlight = vim.fn.synIDtrans(vim.fn.hlID("Label"))
  local label_fg = {
    vim.fn.synIDattr(label_highlight, "fg", "gui"),
    vim.fn.synIDattr(label_highlight, "fg", "cterm"),
  }
  vim.cmd(
    string.format("highlight %s guisp=%s gui=undercurl cterm=undercurl", "IndentBlanklineContextStart", label_fg[1])
  )
end

vim.cmd([[
augroup ColorHack
  au!
  au ColorScheme * lua __my_hacks.hl()
augroup END
]])
