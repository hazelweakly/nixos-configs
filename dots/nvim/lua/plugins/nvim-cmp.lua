---@diagnostic disable: missing-fields

local has_words_before = function()
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "onsails/lspkind-nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    -- {
    --   "zbirenbaum/copilot-cmp",
    --   dependencies = "copilot.lua",
    --   opts = {},
    --   config = function(_, opts)
    --     local copilot_cmp = require("copilot_cmp")
    --     copilot_cmp.setup(opts)
    --     -- attach cmp source whenever copilot attaches
    --     -- fixes lazy-loading issues with the copilot cmp source
    --     vim.api.nvim_create_autocmd("LspAttach", {
    --       callback = function(args)
    --         local client = vim.lsp.get_client_by_id(args.data.client_id)
    --         if client and client.name == "copilot" then
    --           copilot_cmp._on_insert_enter({})
    --         end
    --       end,
    --     })
    --   end,
    -- },
  },
  config = function()
    local cmp = require("cmp")

    --- This tab key behaves pretty closely to how vscode does things.
    -- It is used with a configuration that completely disables using
    -- the enter key to confirm completion in any way.
    ---@param d 1 | -1
    ---@param m "'i'" | "'c'" | "'s'"
    ---@return function
    local function tab(d, m)
      local fwd = d == 1
      return vim.schedule_wrap(function(fallback)
        local s = require("luasnip")

        if m == "c" then
          return cmp.visible() and has_words_before() and (fwd and cmp.select_next_item or cmp.select_prev_item)()
            or cmp.complete()
        end

        if fwd and cmp.visible() and has_words_before() then
          cmp.confirm({ select = true })
        elseif (fwd and s.expand_or_jumpable or s.jumpable)(d) then
          (fwd and s.expand_or_jump or s.jump)(d)
        else
          fallback()
        end
      end)
    end

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Down>"] = cmp.mapping({
          i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          s = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        }),
        ["<Up>"] = cmp.mapping({
          i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          s = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping({
          i = cmp.mapping.complete(),
          c = function(fallback)
            if cmp.visible() then
              return cmp.complete_common_string()
            else
              fallback()
            end
          end,
        }),
        ["<CR>"] = cmp.config.disable,
        ["<Tab>"] = cmp.mapping({
          i = tab(1, "i"),
          s = tab(1, "s"),
          c = tab(1, "c"),
        }),
        ["<S-Tab>"] = cmp.mapping({
          i = tab(-1, "i"),
          c = tab(-1, "c"),
          s = tab(-1, "s"),
        }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", max_item_count = 10 },
        -- place snips second otherwise ctrl+space doesn't give relevant completion
        { name = "luasnip", max_item_count = 5 },
        { name = "buffer", keyword_length = 3 },
        { name = "path", trigger_characters = { "/" } },
        { name = "copilot", max_item_count = 2, keyword_length = 3 },
      }),
      formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol",
          max_width = 50,
          symbol_map = { Copilot = "" },
        }),
      },
      window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
      -- disable when using copilot
      -- experimental = {
      --   ghost_text = {
      --     hl_group = "LspCodeLens",
      --   },
      -- },
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path", option = { keyword_length = 2 } },
      }, {
        { name = "cmdline", option = { keyword_length = 2 } },
      }),
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
