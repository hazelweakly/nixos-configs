vim.api.nvim_create_augroup("_settings", {})
vim.api.nvim_create_autocmd("VimResized", {
  group = "_settings",
  command = "tabdo wincmd =",
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "_settings",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual" })
  end,
})
