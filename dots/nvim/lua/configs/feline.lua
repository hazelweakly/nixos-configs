local clr = require("configs.colors").get()
local colors = require("configs.utils").merge(clr.colors, {
  white = clr.colors.fg_sidebar,
  fg = clr.colors.fg_sidebar,
  bg = clr.colors.bg_statusline,
})

local lsp = require("feline.providers.lsp")
local lsp_severity = vim.diagnostic.severity

local statusline_style = {
  left = "",
  right = "",
  main_icon = " ",
  vi_mode_icon = " ",
  position_icon = " ",
}

local shortline = true

local mode_colors = {
  ["n"] = { "NORMAL ", colors.red },
  ["no"] = { "N-PEND", colors.red },
  ["i"] = { "INSERT ", colors.purple },
  ["ic"] = { "INSERT ", colors.purple },
  ["t"] = { "TERMINL", colors.green },
  ["v"] = { "VISUAL ", colors.cyan },
  ["V"] = { "V-LINE ", colors.cyan },
  [""] = { "V-BLOCK", colors.cyan },
  ["R"] = { "REPLACE", colors.orange },
  ["Rv"] = { "V-REPLC", colors.orange },
  ["s"] = { "SELECT ", colors.blue },
  ["S"] = { "S-LINE ", colors.blue },
  [""] = { "S-BLOCK", colors.blue },
  ["c"] = { "COMMAND", colors.magenta2 },
  ["cv"] = { "COMMAND", colors.magenta2 },
  ["ce"] = { "COMMAND", colors.magenta2 },
  ["r"] = { "PROMPT ", colors.teal },
  ["rm"] = { "MORE   ", colors.teal },
  ["r?"] = { "CONFIRM", colors.teal },
  ["!"] = { "SHELL  ", colors.green },
}

local should_enable = shortline or function(winid)
  return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
end

local mc = function()
  return mode_colors[vim.fn.mode()]
end

local hl_fn = function()
  return { fg = mc()[2] }
end

local pad = function(s)
  return " " .. s .. " "
end

local components = {
  active = { {}, {}, {} },
  inactive = {},
}

components.active[1][1] = {
  provider = statusline_style.main_icon,

  hl = { fg = colors.bg, bg = colors.blue },

  right_sep = {
    str = statusline_style.right,
    hl = { fg = colors.blue, bg = colors.bg },
  },
}

components.active[1][2] = {
  provider = function()
    local filename = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")
    local icon = require("nvim-web-devicons").get_icon(filename, extension)
    if icon == nil then
      icon = " "
      return icon
    end
    return " " .. icon .. " " .. filename .. " "
  end,
  enabled = shortline or function(winid)
    return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
  end,

  right_sep = { str = statusline_style.right, hl = { fg = colors.bg, bg = colors.bg_dark } },
}

components.active[1][3] = {
  provider = function()
    local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    return "  " .. dir_name .. " "
  end,

  enabled = shortline or function(winid)
    return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
  end,

  hl = { fg = colors.dark5 },
  right_sep = {
    str = statusline_style.right,
    hi = { fg = colors.bg, bg = colors.dark5 },
  },
}

components.active[1][4] = {
  provider = "git_diff_added",
  hl = { fg = colors.dark5 },
  icon = pad(""),
}
components.active[1][5] = {
  provider = "git_diff_changed",
  hl = { fg = colors.dark5 },
  icon = "",
}
components.active[1][6] = {
  provider = "git_diff_removed",
  hl = { fg = colors.dark5 },
  icon = "",
}

components.active[1][7] = {
  provider = "diagnostic_errors",
  enabled = function()
    return lsp.diagnostics_exist(lsp_severity.ERROR)
  end,

  hl = { fg = colors.red },
  icon = "  ",
}

components.active[1][8] = {
  provider = "diagnostic_warnings",
  enabled = function()
    return lsp.diagnostics_exist(lsp_severity.WARN)
  end,
  hl = { fg = colors.yellow },
  icon = "  ",
}

components.active[1][9] = {
  provider = "diagnostic_hints",
  enabled = function()
    return lsp.diagnostics_exist(lsp_severity.HINT)
  end,
  hl = { fg = colors.dark5 },
  icon = "  ",
}

components.active[1][10] = {
  provider = "diagnostic_info",
  enabled = function()
    return lsp.diagnostics_exist(lsp_severity.INFO)
  end,
  hl = { fg = colors.green },
  icon = "  ",
}

components.active[2][1] = {
  provider = function()
    local Lsp = vim.lsp.util.get_progress_messages()[1]

    if Lsp then
      local msg = Lsp.message or ""
      local percentage = Lsp.percentage or 0
      local title = Lsp.title or ""
      local spinners = { "", "", "" }
      local success_icon = { "", "", "" }

      local ms = vim.loop.hrtime() / 1000000
      local frame = math.floor(ms / 120) % #spinners

      if percentage >= 70 then
        return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
      end

      return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
    end

    return ""
  end,
  enabled = shortline or function(winid)
    return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
  end,
  hl = { fg = colors.green },
}

components.active[3][1] = {
  provider = function()
    if next(vim.lsp.buf_get_clients()) ~= nil then
      return "  LSP"
    else
      return ""
    end
  end,
  enabled = shortline or function(winid)
    return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
  end,
  hl = { fg = colors.dark5 },
}

components.active[3][2] = {
  provider = "git_branch",
  enabled = shortline or function(winid)
    return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
  end,
  hl = { fg = colors.dark5 },
  icon = "  ",
}

components.active[3][3] = {
  provider = " " .. statusline_style.left,
  hl = { fg = colors.bg },
}

components.active[3][4] = {
  provider = statusline_style.left,
  hl = hl_fn,
}

components.active[3][5] = {
  provider = statusline_style.vi_mode_icon,
  hl = function()
    return { fg = colors.bg, bg = mc()[2] }
  end,
}

components.active[3][6] = {
  provider = function()
    return pad(mc()[1])
  end,
  hl = hl_fn,
}

components.active[3][7] = {
  provider = statusline_style.left,
  enabled = should_enable,
  hl = { fg = colors.bg },
}

components.active[3][8] = {
  provider = statusline_style.left,
  enabled = should_enable,
  hl = { fg = colors.green },
}

components.active[3][9] = {
  provider = statusline_style.position_icon,
  enabled = should_enable,
  hl = { fg = colors.bg, bg = colors.green },
}

components.active[3][10] = {
  provider = function()
    local current_line = vim.fn.line(".")
    local total_line = vim.fn.line("$")

    if current_line == 1 then
      return " Top "
    elseif current_line == vim.fn.line("$") then
      return " Bot "
    end
    local result, _ = math.modf((current_line / total_line) * 100)
    return " " .. result .. "%% "
  end,

  enabled = should_enable,
  hl = { fg = colors.green, bg = colors.bg },
}

require("feline").setup({ theme = colors, components = components })
