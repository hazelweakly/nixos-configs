-- keep in mind any time you touch after, ftplugin, etc.
-- https://vi.stackexchange.com/a/13456
vim.opt.shadafile = "NONE"

pcall(require, "impatient")

local modules = {
  "_.disable_built_ins",
  "configs.options",
  "configs.mappings",
  "configs.commands",
  "packer_compiled",
  "configs.settings",
}

for _, m in ipairs(modules) do
  pcall(require, m)
end

vim.opt.shadafile = ""
