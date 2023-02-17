return {
  "kosayoda/nvim-lightbulb",
  event = "User DirenvLoaded",
  config = function()
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        require("nvim-lightbulb").update_lightbulb()
      end,
    })
  end,
}
