return {
  "danymat/neogen",
  config = true,
  keys = {
    {
      "<leader>c",
      function()
        require("neogen").generate({})
      end,
    },
  },
}
