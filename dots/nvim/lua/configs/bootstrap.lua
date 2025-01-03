local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--single-branch", "https://github.com/folke/lazy.nvim.git", lazypath })
  local f = io.open(vim.fn.stdpath("config") .. "/lazy-lock.json", "r")
  if f then
    local data = f:read("*a")
    local has, lock = pcall(vim.json.decode, data)
    if not has then
      require("configs.utils").log_err("error loading the bootstrap code. The JSON lockfile is malformed", "[init]")
      return nil
    end
    vim.fn.system({ "git", "-C", lazypath, "checkout", lock["lazy.nvim"].commit })
  end
  -- vim.fn.system({
  --   "perl",
  --   "-pi",
  --   "-e",
  --   "'s/not plugin._.is_local and // if $. == 90'",
  --   "./lua/lazy/manage/task/plugin.lua",
  -- })
end
vim.opt.rtp:prepend(lazypath)
