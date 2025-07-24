return {
  "saghen/blink.cmp",
  dependencies = { "echasnovski/mini.snippets", opts = {} },
  event = "InsertEnter",
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "super-tab" },
    snippets = { preset = "mini_snippets" },

    signature = { enabled = true },

    -- See :h blink-cmp-config-keymap for defining your own keymap
    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      -- ghost_text = { enabled = true },
      documentation = { auto_show = true },
      list = { selection = { auto_insert = false } },
      menu = { draw = { treesitter = { "lsp" } } },
    },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true } },
    },
    sources = {
      providers = {
        lsp = { fallbacks = {} },
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.expand("%:h")
            end,
          },
        },
      },
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
