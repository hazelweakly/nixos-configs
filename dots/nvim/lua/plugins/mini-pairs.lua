return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = { check_ts = true },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
    -- This now lives in the nvim-cmp config cause it shortens loading for markdown files
    -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    -- local cmp = require("cmp")
    -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
