local M = {}

M.log_err = function(msg, title)
  vim.notify(msg, vim.log.levels.ERROR, { title = title })
end

-- https://github.com/neovim/neovim/pull/16591
M.map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, M.merge({ silent = true }, opts or {}))
end

--- Merges recursively two or more map-like tables.
---@return table
M.merge = function(...)
  ---@diagnostic disable-next-line: return-type-mismatch
  return vim.tbl_deep_extend("force", ...)
end

M.buf_map = function(bufnr, mode, lhs, rhs, opts)
  M.map(mode, lhs, rhs, M.merge({ buffer = bufnr }, opts or {}))
end

M.ftplugin = {}
M.ftplugin.undo = function(args)
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
    .. (vim.b.undo_ftplugin ~= nil and " | " or " ")
    .. (type(args) == "table" and table.concat(args, " | ") or args)
end

return M
