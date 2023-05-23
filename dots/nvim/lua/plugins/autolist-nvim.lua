return {
  "gaoDean/autolist.nvim",
  dependencies = { "windwp/nvim-autopairs" },
  ft = { "markdown", "text", "tex", "plaintex" },
  priority = 0,
  config = function()
    local autolist = require("autolist")
    autolist.setup({ invert = { ol_incrementable = "1." } })
    autolist.create_mapping_hook("i", "<CR>", autolist.new)
    autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
    autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
    autolist.create_mapping_hook("i", "<C-T>", autolist.indent)
    autolist.create_mapping_hook("i", "<C-D>", autolist.indent, "<C-D>")
    autolist.create_mapping_hook("n", "o", autolist.new)
    autolist.create_mapping_hook("n", "O", autolist.new_before)
    autolist.create_mapping_hook("n", "<leader>x", autolist.invert_entry, "")
    autolist.create_mapping_hook("n", "<leader>r", autolist.force_recalculate)
    vim.api.nvim_create_autocmd("TextChanged", {
      callback = function()
        if vim.tbl_contains({ "d", "<", ">" }, vim.v.operator) then
          vim.cmd.normal({ autolist.force_recalculate(nil, nil), bang = false })
        end
      end,
    })
  end,
}
