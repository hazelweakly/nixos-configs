vim.api.nvim_create_augroup("BigFileDisable", {})
vim.api.nvim_create_autocmd({ "BufReadPre", "BufReadPost" }, {
  group = "BigFileDisable",
  callback = function()
    vim.schedule(function()
      if require("_.large_file").is_large_file() then
        vim.opt.syntax = "clear"
        vim.bo.undofile = false
        vim.bo.swapfile = false
        vim.bo.bufhidden = "unload"
        vim.bo.buftype = "nowrite"
        vim.wo.foldmethod = "manual"
        vim.wo.foldenable = false
        vim.opt_local.complete:remove("wbuU")
      end
    end)
  end,
})
