vim.api.nvim_create_augroup("MySettings", {})
vim.api.nvim_create_autocmd("VimResized", {
  group = "MySettings",
  command = "tabdo wincmd =",
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "MySettings",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual" })
  end,
})
