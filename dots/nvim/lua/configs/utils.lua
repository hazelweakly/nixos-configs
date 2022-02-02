local M = {}

M.log_err = function(msg, title)
  vim.notify(msg, vim.log.levels.ERROR, { title = title })
end

M.log_info = function(msg, title)
  vim.notify(msg, vim.log.levels.INFO, { title = title })
end

-- https://github.com/neovim/neovim/pull/16591
M.map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, M.merge({ silent = true }, opts or {}))
end

M.merge = function(...)
  return vim.tbl_deep_extend("force", ...)
end

M.buf_map = function(bufnr, mode, lhs, rhs, opts)
  M.map(mode, lhs, rhs, M.merge({ buffer = bufnr }, opts or {}))
end

M.border = {
  { "🭽", "FloatBorder" },
  { "▔", "FloatBorder" },
  { "🭾", "FloatBorder" },
  { "▕", "FloatBorder" },
  { "🭿", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "🭼", "FloatBorder" },
  { "▏", "FloatBorder" },
}

M.ftplugin = {}
M.ftplugin.undo = function(args)
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
    .. (vim.b.undo_ftplugin ~= nil and " | " or " ")
    .. (type(args) == "table" and table.concat(args, " | ") or args)
end

M.packer_lazy_load = function(plugin, timer)
  if plugin then
    timer = timer or 0
    vim.defer_fn(function()
      require("packer").loader(plugin)
    end, timer)
  end
end

return M
