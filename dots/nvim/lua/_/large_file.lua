local M = {}

M.is_large_map = {}

M.get = function(bufnr)
  return M.is_large_map["b" .. bufnr]
end

M.set = function(bufnr, val)
  M.is_large_map["b" .. bufnr] = val
  return val
end

M.is_large = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
  return fsize >= 512 * 1024 or fsize <= -2 or vim.api.nvim_buf_line_count(bufnr) > 5000
end

M.is_large_file = function(_, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return M.get(bufnr) or M.set(bufnr, M.is_large(bufnr))
end

return M
