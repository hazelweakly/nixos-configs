return {
  "jayp0521/mason-null-ls.nvim",
  config = function()
    require("mason-null-ls").setup({
      automatic_installation = { exclude = { "stylua", "shellharden" } },
      automatic_setup = false,
    })
  end,
}
