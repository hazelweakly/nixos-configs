return {
  "907th/vim-auto-save",
  event = "FocusLost",
  init = function()
    vim.g.auto_save = 1
    vim.g.auto_save_silent = 1
    vim.g.auto_save_write_all_buffers = 1
    vim.g.auto_save_events = { "FocusLost" }
  end,
}
