require("fidget").setup({
  sources = {
    ["null-ls"] = { ignore = true },
    ltex = { ignore = true },
  },
  timer = { fidget_decay = 250, task_decay = 75, spinner_rate = 50 },
  text = { spinner = "dots" },
})
