return {
  "folke/noice.nvim",
  init = function()
    local map = require("configs.utils").map
    map({ "n", "i", "s" }, "<c-f>", function()
      if not require("noice.lsp").scroll(4) then
        return "<c-f>"
      end
    end, { expr = true })

    map({ "n", "i", "s" }, "<c-b>", function()
      if not require("noice.lsp").scroll(-4) then
        return "<c-b>"
      end
    end, { expr = true })
  end,
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = { command_palette = true, lsp_doc_border = true },
    routes = {
      { filter = { event = "msg_show", kind = "", find = "%[w%]" }, opts = { skip = true } },
    },
  },
  dependenies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "nvim-treesitter",
  },
}
