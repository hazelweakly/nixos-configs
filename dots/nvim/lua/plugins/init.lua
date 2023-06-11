return {
  "folke/lazy.nvim",
  { "MunifTanjim/nui.nvim", lazy = true },
  { "direnv/direnv.vim", enabled = false },
  { "mickael-menu/zk-nvim", lazy = true },
  { "simrat39/rust-tools.nvim", lazy = true },
  {
    "mrcjkb/haskell-tools.nvim",
    -- technically requires telescope if it's available,
    -- but this massively slows down startup
    -- so instead we simply don't load telescope first
    dependencies = { "nvim-lua/plenary.nvim", lazy = true },
    lazy = true,
  },
  { "folke/neodev.nvim", opts = { lspconfig = false }, lazy = true },
  { "b0o/schemastore.nvim", lazy = true },
  "wsdjeg/vim-fetch",
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    lazy = true,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
}
