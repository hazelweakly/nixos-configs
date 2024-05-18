return {
  -- "kosayoda/nvim-lightbulb",
  "gh-liu/nvim-lightbulb",
  event = "LspAttach",
  config = function()
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        require("nvim-lightbulb").update_lightbulb()
      end,
    })
  end,
}
