return {
  "VonHeikemen/lsp-zero.nvim",
  config = function()
    local lsp = require("lsp-zero")
    lsp.preset("recommended")
    lsp.set_preferences({
      set_lsp_keymaps = false,
      manage_nvim_cmp = false,
    })
    lsp.nvim_workspace({
      library = vim.api.nvim_get_runtime_file("", true),
    })
    lsp.on_attach(require("_.lsp").on_attach)

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
          lsp.build_options(s, {})
        else
          lsp.configure(s, s_opts)
        end
      end
    end

    lsp.setup()

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
