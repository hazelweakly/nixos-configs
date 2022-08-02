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

--- Merges recursively two or more map-like tables.
---@return table
M.merge = function(...)
  ---@diagnostic disable-next-line: return-type-mismatch
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

---The file system path separator for the current platform.
M.path_separator = "/"
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
if M.is_windows == true then
  M.path_separator = "\\"
end

---Split string into a table of strings using a separator.
---@param inputString string The string to split.
---@param sep string The separator to use.
---@return table table A table of strings.
M.split = function(inputString, sep)
  local fields = {}

  local pattern = string.format("([^%s]+)", sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end

---Joins arbitrary number of paths together.
---@param ... string The paths to join.
---@return string
M.path_join = function(...)
  local args = { ... }
  if #args == 0 then
    return ""
  end

  local all_parts = {}
  if type(args[1]) == "string" and args[1]:sub(1, 1) == M.path_separator then
    all_parts[1] = ""
  end

  for _, arg in ipairs(args) do
    local arg_parts = M.split(arg, M.path_separator)
    vim.list_extend(all_parts, arg_parts)
  end
  return table.concat(all_parts, M.path_separator)
end

return M
