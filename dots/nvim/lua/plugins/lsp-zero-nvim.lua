return {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lua" },

    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
  },
  config = function()
    local lsp = require("lsp-zero")
    lsp.preset("recommended")
    lsp.set_preferences({
      set_lsp_keymaps = false,
      manage_nvim_cmp = false,
      suggest_lsp_servers = false,
    })

    local lsp_init = require("_.lsp")
    lsp.on_attach(lsp_init.on_attach)

    local servers = {
      "bashls",
      "cssls",
      "dockerls",
      "eslint",
      "gopls",
      "hls",
      "html",
      "jsonls",
      "nil_ls",
      "pyright",
      "rust_analyzer",
      "lua_ls",
      "tailwindcss",
      "terraformls",
      "tsserver",
      "vimls",
      "yamlls",
    }

    for _, s in pairs(servers) do
      local has, s_opts = pcall(require, "_.lsp." .. s)
      if has then
        if type(s_opts) == "function" then
          lsp.skip_server_setup({ s })
        else
          lsp.configure(s, s_opts)
        end
      end
    end

    lsp.setup()

    for _, s in pairs(servers) do
      local has, s_opts = pcall(require, "_.lsp." .. s)
      if has and type(s_opts) == "function" then
        s_opts(lsp.build_options(s, {}))
      end
    end

    for _, s in pairs(servers) do
      local has, s_opts = pcall(require, "_.lsp." .. s)
      if has then
        if type(s_opts) == "function" then
          s_opts(lsp.build_options(s, {}))
        end
      end
    end
  end,
}
