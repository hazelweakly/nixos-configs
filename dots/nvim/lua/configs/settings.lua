local group = vim.api.nvim_create_augroup("MySettings", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  command = "tabdo wincmd =",
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual" })
  end,
})
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function(opts)
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_buf_call(opts.buf, function()
        vim.cmd.doautocmd("BufWritePre")
        vim.cmd.write({ mods = { silent = true } })
      end)
    end
  end,
  group = group,
})
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group,
  command = "checktime",
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", vim.cmd.close, { buffer = event.buf, silent = true, nowait = true })
  end,
})
