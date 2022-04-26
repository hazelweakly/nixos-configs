local M = {}

local safe_require = function(theme_name, package)
  local loaded, theme = pcall(require, theme_name)
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
    vim.cmd("colorscheme tokyonight")
    vim.highlight.link("TSDefinitionUsage", "CursorLine", true)
    vim.highlight.link("TSDefinition", "CursorLine", true)
    vim.highlight.link("HlSearchFloat", "CursorLine", true)
    vim.highlight.link("HlSearchLensNear", "CursorLine", true)
    vim.highlight.link("HlSearchLens", "CursorLine", true)
    local colors = M.tokyonight.get().colors -- error warning info hint
    for level, color in pairs({
      DEBUG = colors.hint,
      ERROR = colors.error,
      INFO = colors.info,
      TRACE = colors.hint,
      WARN = colors.warning,
    }) do
      for _, i in ipairs({ "Border", "Icon", "Title", "Body" }) do
        vim.highlight.create("Notify" .. level .. i, { guifg = color })
      end
    end
  end,
  get = function()
    return require("tokyonight.theme").setup()
  end,
  setup = function()
    vim.g.tokyonight_italic_functions = 1
    vim.wo.colorcolumn = "99999"
    vim.o.termguicolors = true
    local theme = vim.fn.readfile(vim.fn.expand("~/.local/share/theme"))[1]
    M.tokyonight.set_theme({ args = theme or "light" })
    vim.defer_fn(M.add_user_cmd, 50)
  end,
}

M.nightfox = {
  set_theme = function(args)
    local nightfox = safe_require("nightfox", "nightfox.nvim")
    if not nightfox then
      return nil
    end
    local theme = args.args or "light"
    local cur = vim.g.tokyonight_style or "day"
    local cur_theme = vim.g.colors_name or "default"
    vim.g.tokyonight_style = theme == "dark" and "night" or "day"
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
