require("lazy").setup({ import = "plugins" }, {
  change_detection = { notify = false },
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "matchparen",
        "rrhelper",
        "spellfile",
        "spellfile_plugin",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
  -- This is a bit slower but useful for debugging / profiling performance
  -- profiling = {
  --   -- Enables extra stats on the debug tab related to the loader cache.
  --   -- Additionally gathers stats about all package.loaders
  --   loader = false,
  --   -- Track each new require in the Lazy profiling tab
  --   require = false,
  -- },
  install = { colorscheme = { "tokyonight", "habamax" } },
})
