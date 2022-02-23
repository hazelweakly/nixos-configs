local M = {}

M.set_theme = function(args)
  local loaded, tokyonight = pcall(require, "tokyonight")
  if not loaded then
    loaded, _ = pcall(vim.cmd, "packadd tokyonight.nvim")
    if loaded then
      loaded, tokyonight = pcall(require, "tokyonight")
    end
  end
  if not loaded then
    return nil
  end

  local theme = args.args or "light"
  local cur = vim.g.tokyonight_style or "day"
  local cur_theme = vim.g.colors_name or "default"
  vim.g.tokyonight_style = theme == "dark" and "night" or "day"

  if vim.g.tokyonight_style ~= cur or cur_theme ~= "tokyonight" then
    vim.o.background = theme
  end
  package.loaded["tokyonight.config"] = nil
  tokyonight.colorscheme()
  vim.defer_fn(function()
    vim.highlight.link("TSDefinitionUsage", "CursorLine", true)
    vim.highlight.link("TSDefinition", "CursorLine", true)
    local colors = M.get().colors -- error warning info hint
    for level, color in
      pairs({
        DEBUG = colors.hint,
        ERROR = colors.error,
        INFO = colors.info,
        TRACE = colors.hint,
        WARN = colors.warning,
      })
    do
      for _, i in ipairs({ "Border", "Icon", "Title", "Body" }) do
        vim.highlight.create("Notify" .. level .. i, { guifg = color })
      end
    end
  end, 100)
end

M.setup = function()
  vim.g.tokyonight_italic_functions = 1
  vim.wo.colorcolumn = "99999"
  vim.o.termguicolors = true
  local theme = vim.fn.readfile(vim.fn.expand("~/.local/share/theme"))[1]
  -- local theme = require("plenary.path"):new("~/.local/share/theme"):head(1)
  M.set_theme({ args = theme or "light" })
  vim.defer_fn(M.add_user_cmd, 50)
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
