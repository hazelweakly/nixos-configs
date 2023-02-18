return {
  "folke/noice.nvim",
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
