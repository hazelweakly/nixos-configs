local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--single-branch", "https://github.com/folke/lazy.nvim.git", lazypath })
  local f = io.open(vim.fn.stdpath("config") .. "/lazy-lock.json", "r")
  if f then
    local data = f:read("*a")
    local lock = vim.json.decode(data)
    ---@diagnostic disable-next-line: need-check-nil
    vim.fn.system({ "git", "-C", lazypath, "checkout", lock["lazy.nvim"].commit })
  end
end
vim.opt.rtp:prepend(lazypath)
local treesitter = os.getenv("TREESITTER_PLUGIN")
if treesitter == nil then
  require("configs.utils").log_err("error loading treesitter, $TREESITTER_PLUGIN is empty", "[init]")
end

require("lazy").setup({ import = "plugins" }, {
  change_detection = { notify = false },
  performance = {
    rtp = {
      paths = { treesitter .. "/pack/myNeovimPackages/start/*" },
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "matchparen",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
})
