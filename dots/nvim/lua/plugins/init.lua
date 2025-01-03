-- TODO: https://github.com/stevearc/oil.nvim
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
  -- { "zk-org/zk-nvim", lazy = true },
  { "simrat39/rust-tools.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "ethanholz/nvim-lastplace", opts = {}, event = "BufReadPre" },
  { "notjedi/nvim-rooter.lua", config = true, event = "BufReadPost" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "tyru/open-browser.vim", keys = { { "gx", "<Plug>(openbrowser-smart-search)" } } },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = { check_ts = true } },
  { "terrastruct/d2-vim", ft = "d2" },
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
  },
  { "folke/neodev.nvim", opts = { lspconfig = false }, lazy = true },
  { "b0o/schemastore.nvim", lazy = true },
  "wsdjeg/vim-fetch",
}
