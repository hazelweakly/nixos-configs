return {
  "danymat/neogen",
  config = true,
  init = function()
    require("configs.utils").map("n", "<Leader>c", function()
      require("neogen").generate({})
    end)
  end,
}
