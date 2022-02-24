require("neogen").setup()
require("configs.utils").map("n", "<Leader>c", function()
  return require("neogen").generate()
end)
