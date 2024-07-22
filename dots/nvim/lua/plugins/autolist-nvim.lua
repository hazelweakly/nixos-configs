return {
  "gaoDean/autolist.nvim",
  dependencies = { "windwp/nvim-autopairs" },
  ft = { "markdown", "text", "tex", "plaintex" },
  priority = 0,
  config = function()
    require("autolist").setup({
      colon = { indent_raw = false },
      cycle = { "-", "1." },
    })

    vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>", { buffer = 0 })
    vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>", { buffer = 0 })
    vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>", { buffer = 0 })
    vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>", { buffer = 0 })
    vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", { buffer = 0 })
    vim.keymap.set("n", "<leader>x", "<cmd>AutolistToggleCheckbox<cr>", { buffer = 0 })
    vim.keymap.set("n", "<leader>r", "<cmd>AutolistRecalculate<cr>", { buffer = 0 })

    vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true, buffer = 0 })
    vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true, buffer = 0 })

    vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>", { buffer = 0 })
    vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>", { buffer = 0 })
    -- vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>", {buffer=0})
    vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>", { buffer = 0 })
  end,
}
