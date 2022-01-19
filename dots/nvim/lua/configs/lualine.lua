local theme = require("lualine").get_config()

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 90
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
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

local function lsp_provider()
  local Lsp = vim.lsp.util.get_progress_messages()[1]

  if Lsp then
    local percentage = Lsp.percentage or 0
    local spinners = { "", "", "" }
    local success_icon = { "", "", "" }

    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    local icons = percentage >= 70 and success_icon or spinners

    return string.format(" %%<%s %s %s (%s%%%%) ", icons[frame + 1], Lsp.title or "", Lsp.message or "", percentage)
  end

  return ""
end

local function has_lsp()
  if next(vim.lsp.buf_get_clients()) ~= nil then
    return "  LSP"
  else
    return ""
  end
end

theme = require("configs.utils").merge(theme, {
  options = { theme = "tokyonight" },
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
      {
        "diagnostics",
        symbols = { error = "  ", warn = "  ", info = "  ", hint = "  " },
        update_in_insert = true,
      },
    },
    lualine_c = { { "%=", separator = "" }, lsp_provider },
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
