-- keep in mind any time you touch after, ftplugin, etc.
-- https://vi.stackexchange.com/a/13456
vim.opt.shadafile = "NONE"

for _, m in
  ipairs({
    "_.large_file_detect",
    "impatient",
    "_.disable_built_ins",
    "configs.options",
    "configs.filetype-nvim",
    "configs.mappings",
    "plugins",
    "configs.settings",
  })
do
  if not pcall(require, m) then
    require("configs.utils").log_err("error loading " .. m, "[init]")
  end
end

require("configs.colors").setup()
vim.opt.shadafile = ""
