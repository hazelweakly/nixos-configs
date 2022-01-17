local M = {}

local function unload(module_pattern, reload)
  reload = reload or false
  for module, _ in pairs(package.loaded) do
    if module:match(module_pattern) then
      package.loaded[module] = nil
      if reload then
        require(module)
      end
    end
  end
end

local function clear_cache()
  if 0 == vim.fn.delete(vim.fn.stdpath("config") .. "/packer/packer_compiled.lua") then
    vim.cmd(":LuaCacheClear")
  end
end

M.log_err = function(msg, title)
  vim.notify(msg, vim.log.levels.ERROR, { title = title })
end

M.log_info = function(msg, title)
  vim.notify(msg, vim.log.levels.INFO, { title = title })
end

-- https://github.com/neovim/neovim/pull/16591
M.map = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = M.merge(options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

M.merge = function(...)
  return vim.tbl_deep_extend("force", ...)
end

M.buf_map = function(bufnr, mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = M.merge(options, opts)
  end
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

M.reload_user_config_sync = function()
  M.reload_user_config()
  clear_cache()
  unload("utils.config", true)
  unload("utils.plugins", true)
  vim.cmd(":PackerSync")
end

M.reload_user_config = function(compile)
  compile = compile or false
  unload("utils.config", true)
  if compile then
    vim.cmd(":PackerCompile")
  end
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

