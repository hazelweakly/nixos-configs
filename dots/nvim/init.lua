vim.loader.enable()

for _, m in ipairs({
  "configs.options",
  "configs.filetype-nvim",
  "configs.lazy",
  "configs.mappings",
  "configs.settings",
}) do
  if not pcall(require, m) then
    require("configs.utils").log_err("error loading " .. m, "[init]")
  end
end
