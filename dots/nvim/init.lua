vim.loader.enable() -- speeds up init by ~2ms for some reason
for _, m in ipairs({
  "configs.bootstrap",
  "configs.options",
  "configs.lazy",
  "configs.filetype-nvim",
  "configs.mappings",
  "_.lsp",
  "configs.settings",
}) do
  if not pcall(require, m) then
    require("configs.utils").log_err("error loading " .. m, "[init]")
  end
end

vim.defer_fn(function()
  if vim.v.exiting ~= vim.NIL then
    return
  end
  vim.g.did_ultra_lazy = true
  vim.api.nvim_exec_autocmds("User", { pattern = "UltraLazy", modeline = false })
end, 100)
