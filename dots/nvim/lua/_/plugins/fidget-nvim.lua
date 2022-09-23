require("fidget").setup({
  sources = {
    ["null-ls"] = { ignore = true },
    ltex = { ignore = true },
  },
})
vim.api.nvim_create_autocmd("VimLeavePre", { command = [[silent! FidgetClose]] })
