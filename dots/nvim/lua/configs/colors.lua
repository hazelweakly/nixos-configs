local M = {}

local function link_hl(a, b)
  vim.api.nvim_set_hl(0, a, { link = b })
end

local safe_require = function(theme_name, package)
  local loaded, theme = pcall(require, theme_name)
  ---@diagnostic disable-next-line: param-type-mismatch
  if not loaded and pcall(vim.cmd, "packadd " .. package) then
    loaded, theme = pcall(require, theme_name)
  end
  if not loaded then
    return nil
  end
  return theme
end

M.tokyonight = {
  set_theme = function(args)
    local tokyonight = safe_require("tokyonight", "tokyonight.nvim")
    if not tokyonight then
      return nil
    end

    local theme = args.args or "light"
    local cur = vim.g.tokyonight_style or "day"
    local cur_theme = vim.g.colors_name or "default"
    vim.g.tokyonight_style = theme == "dark" and "night" or "day"

    if vim.g.tokyonight_style ~= cur or cur_theme ~= "tokyonight" then
      vim.o.background = theme
    end
    require("tokyonight").setup({
      style = vim.g.tokyonight_style,
      on_highlights = function(hl, colors)
        link_hl("TSDefinitionUsage", "CursorLine")
        link_hl("TSDefinition", "CursorLine")
        link_hl("HlSearchFloat", "CursorLine")
        link_hl("HlSearchLensNear", "CursorLine")
        link_hl("HlSearchLens", "CursorLine")
        for level, color in pairs({
          DEBUG = colors.hint,
          ERROR = colors.error,
          INFO = colors.info,
          TRACE = colors.hint,
          WARN = colors.warning,
        }) do
          for _, i in ipairs({ "Border", "Icon", "Title", "Body" }) do
            vim.api.nvim_set_hl(0, "Notify" .. level .. i, { fg = color })
          end
        end
      end,
    })
    vim.cmd("colorscheme tokyonight-" .. vim.g.tokyonight_style)
  end,
  get = function()
    return {
      colors = require("tokyonight.colors").setup(
        require("configs.utils").merge(require("tokyonight.config"), { style = vim.g.tokyonight_style })
      ),
    }
  end,
  setup = function()
    vim.g.tokyonight_italic_functions = 1
    vim.wo.colorcolumn = "99999"
    vim.o.termguicolors = true
    ---@diagnostic disable-next-line: missing-parameter
    local theme = vim.fn.readfile(vim.fn.expand("~/.local/share/theme"))[1]
    M.tokyonight.set_theme({ args = theme or "light" })
    vim.defer_fn(M.add_user_cmd, 50)
  end,
}

M.set_theme = M.tokyonight.set_theme

M.add_user_cmd = function()
  vim.api.nvim_create_user_command("SetTheme", M.set_theme, {
    nargs = "?",
    complete = function(arg, _, _)
      local options = { "light", "dark" }
      local t = {}
      for _, v in ipairs(options) do
        if string.find(v, arg, 1, true) then
          table.insert(t, v)
        end
      end
      return t
    end,
  })
end

return M.tokyonight
