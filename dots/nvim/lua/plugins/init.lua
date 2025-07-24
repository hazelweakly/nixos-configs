-- TODO: https://github.com/stevearc/oil.nvim

local M = {}
M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

function M.lazy_file()
  -- Add support for the LazyFile event
  local Event = require("lazy.core.handler.event")

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end
M.lazy_file()

return {
  {
    "folke/lazy.nvim",
    build = {
      -- Behold, the horrors we do in order to achieve "normal plugin updating behavior"
      -- in the case when one of the plugins happens to be read-only (nvim-treesitter)
      --
      -- Amusingly, this is a silent update that comes from this commit:
      -- <https://github.com/folke/lazy.nvim/commit/60cf258a9ae7fffe04bb31141141a91845158dcc>
      -- Naturally, something something xkcd workflow etc etc. Anyways, ...
      [[perl -pi -e "s/not plugin._.is_local and // if $. == 90" ./lua/lazy/manage/task/plugin.lua ]],
      -- Due to some very interesting regex choices that were made,                               ^
      -- this whitespace is load-bearing, don't fuck with it         --------v            --------|
      [[git update-index --assume-unchanged ./lua/lazy/manage/task/plugin.lua ]],
    },
  },
  { "MunifTanjim/nui.nvim", lazy = true, enabled = false },
  { "direnv/direnv.vim", enabled = false },
  { "mrcjkb/rustaceanvim", version = "^6", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "ethanholz/nvim-lastplace", opts = {}, event = "LazyFile" },
  { "notjedi/nvim-rooter.lua", config = true, event = "LazyFile" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "tyru/open-browser.vim", keys = { { "gx", "<Plug>(openbrowser-smart-search)" } } },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = { check_ts = true } },
  { "terrastruct/d2-vim", ft = "d2" },
  { "mrcjkb/haskell-tools.nvim", dependencies = { "nvim-lua/plenary.nvim" }, lazy = true },
  { "folke/neodev.nvim", opts = { lspconfig = false }, lazy = true },
  { "b0o/schemastore.nvim", lazy = true },
  "wsdjeg/vim-fetch",
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = "typescript",
    opts = {},
  },
}
