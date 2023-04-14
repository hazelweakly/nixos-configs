return {
  "wellle/targets.vim",
  event = "CursorMoved",
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "targets#mappings#user",
      command = [[call targets#mappings#extend({ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]} })]],
    })
  end,
}
