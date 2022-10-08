-- keep in mind any time you touch after, ftplugin, etc.
-- https://vi.stackexchange.com/a/13456
--
-- List of breaking changes: https://github.com/neovim/neovim/issues/14090
vim.opt.shadafile = "NONE"
local is_root = vim.env.USER == "root"

for _, m in ipairs({
  "impatient",
  "_.large_file_detect",
  "_.disable_built_ins",
  "configs.options",
  "configs.filetype-nvim",
  "configs.mappings",
  "plugins",
  "configs.settings",
}) do
  if not pcall(require, m) then
    require("configs.utils").log_err("error loading " .. m, "[init]")
  end
end

require("configs.colors").setup()

if is_root then
  vim.opt.shada = ""
else
  vim.opt.shadafile = ""
end
