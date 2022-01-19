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
  if 0 == vim.fn.delete(vim.fn.stdpath("config") .. "/lua/packer_compiled.lua") then
    local loaded, impatient = pcall(require, "impatient")
    if loaded then
      impatient.clear_cache()
    end
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
  vim.keymap.set(mode, lhs, rhs, M.merge({ silent = true }, opts or {}))
end

M.merge = function(...)
  return vim.tbl_deep_extend("force", ...)
end

M.buf_map = function(bufnr, mode, lhs, rhs, opts)
  M.map(mode, lhs, rhs, M.merge({ buffer = bufnr }, opts or {}))
end

M.reload_user_config_sync = function(sync)
  sync = sync or false
  M.reload_user_config()
  if sync then
    require("packer").sync()
  end
end

M.reload_user_config = function(compile)
  compile = compile or false
  clear_cache()
  unload("packer_compiled", false)
  unload("configs.*$", false)
  if compile then
    require("packer").compile()
  end
end

M.packer_pre_fn = {
  Sync = function()
    M.reload_user_config_sync()
  end,
  Compile = function()
    M.reload_user_config()
  end,
}

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
