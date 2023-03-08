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
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
    views = {
      popup = { border = { style = require("configs.utils").border_simple } },
      hover = { border = { style = require("configs.utils").border_simple } },
      confirm = { border = { style = require("configs.utils").border_simple } },
      cmdline_popup = { border = { style = require("configs.utils").border_simple } },
    },
  },
  dependenies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "nvim-treesitter",
  },
}
