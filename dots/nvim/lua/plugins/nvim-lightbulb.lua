return {
  "kosayoda/nvim-lightbulb",
  event = "VeryLazy",
  config = function()
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        require("nvim-lightbulb").update_lightbulb()
      end,
    })
  end,
}
