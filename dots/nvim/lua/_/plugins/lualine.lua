local theme = require("lualine").get_config()

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 90
  end,
}

local function dirname()
  return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

local function filenameIcon()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")
  local icon = require("nvim-web-devicons").get_icon(filename, extension) or ""
  return icon .. " " .. filename
end

local function has_lsp()
  return next(vim.lsp.buf_get_clients()) ~= nil and "  LSP" or ""
end

theme = require("configs.utils").merge(theme, {
  options = { globalstatus = true },
  sections = {
    lualine_a = {
      {
        dirname,
        padding = { left = 0, right = 1 },
        cond = function()
          return conditions.buffer_not_empty() and conditions.hide_in_width()
        end,
      },
      { filenameIcon, cond = conditions.buffer_not_empty },
    },
    lualine_b = {
      { "branch", cond = conditions.hide_in_width },
      { "diff", symbols = { added = " ", removed = " ", modified = " " } },
    },
    lualine_c = {
      {
        "diagnostics",
        symbols = { error = "  ", warn = "  ", info = "  ", hint = "  " },
        update_in_insert = true,
      },
    },
    lualine_x = {
      { has_lsp, cond = conditions.hide_in_width },
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
})

require("lualine").setup(theme)
