local M = {}

M.set_theme = function(args)
  local theme = args.args or "light"
  local cur = vim.g.tokyonight_style or "day"
  local cur_theme = vim.g.colors_name or "default"
  vim.g.tokyonight_style = theme == "dark" and "night" or "day"

  if vim.g.tokyonight_style ~= cur or cur_theme ~= "tokyonight" then
    vim.o.background = theme
  end
  require("tokyonight").colorscheme()
  vim.highlight.link("TSDefinitionUsage", "CursorLine")
  vim.highlight.link("TSDefinition", "CursorLine")
end

M.setup = function()
  vim.g.tokyonight_italic_functions = 1
  vim.wo.colorcolumn = "99999"
  vim.o.termguicolors = true
  local theme = require("plenary.path"):new("~/.local/share/theme"):head(1)
  M.set_theme({ args = theme or "light" })
  M.add_user_cmd()
end

M.add_user_cmd = function()
  vim.api.nvim_add_user_command("SetTheme", M.set_theme, {
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

M.get = function()
  return require("tokyonight.theme").setup()
end

return M
