return {
  "VonHeikemen/lsp-zero.nvim",
  enabled = false,
  branch = "v2.x",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },
  -- config = function()
  --   local lsp = require("lsp-zero")
  --   lsp.preset({
  --     manage_nvim_cmp = false,
  --     suggest_lsp_servers = false,
  --     call_servers = "global",
  --     setup_servers_on_start = false,
  --   })
  --
  --   local lsp_init = require("_.lsp")
  --   lsp.on_attach(lsp_init.on_attach)
  --
  -- end,
}
