local M = {}
M.tokyonight = {
  set_theme = function(args)
    if not pcall(require, "tokyonight") then
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
