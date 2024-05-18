return {
  "nvim-lualine/lualine.nvim",
  event = "User UltraLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 90
      end,
    }

    return {
      options = { globalstatus = true },
      sections = {
        lualine_a = {
          {
            function()
              return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end,
            padding = { left = 1, right = 1 },
            cond = function()
              return conditions.buffer_not_empty() and conditions.hide_in_width()
            end,
          },
          {
            function()
              local filename = vim.fn.expand("%:t")
              local extension = vim.fn.expand("%:e")
              local icon = require("nvim-web-devicons").get_icon(filename, extension) or ""
              return icon .. " " .. filename
            end,
            cond = conditions.buffer_not_empty,
          },
        },
        lualine_b = {
          { "branch", cond = conditions.hide_in_width },
          { "diff", symbols = { added = " ", removed = " ", modified = " " } },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = "", hint = "󰌵" },
            update_in_insert = true,
          },
        },
        lualine_x = {
          {
            function()
              return next(vim.lsp.get_clients()) ~= nil and "  LSP" or ""
            end,
            cond = conditions.hide_in_width,
          },
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 4)
            end,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { { "location", padding = { left = 1, right = 0 }, cond = conditions.hide_in_width } },
      },
    }
  end,
}
