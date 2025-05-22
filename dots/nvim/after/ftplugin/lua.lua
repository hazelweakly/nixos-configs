if not pcall(require, "nvim-surround") then
  return nil
end
require("nvim-surround").buffer_setup({
  surrounds = {
    ["p"] = {
      add = { "vim.pretty_print(", ")" },
      find = "vim%.pretty_print%b()",
      delete = "^(vim%.pretty_print%()().-(%))()$",
      change = {
        target = "^(vim%.pretty_print%()().-(%))()$",
      },
    },
    ["s"] = {
      add = { "[[", "]]" },
      find = "%[%[().-()%]%]", -- ??
      -- delete = "^(vim%.pretty_print%()().-(%))()$",
      -- change = {
      --   target = "^(vim%.pretty_print%()().-(%))()$",
      -- },
    },
  },
})
-- vim.lsp.start()
