return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
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
      return function(fallback)
        local s, ng = require("luasnip"), require("neogen")

        if m == "c" then
          return cmp.visible() and (fwd and cmp.select_next_item or cmp.select_prev_item)() or cmp.complete()
        end

        if fwd and cmp.visible() then
          cmp.confirm({ select = true })
        elseif (fwd and s.expand_or_jumpable or s.jumpable)(d) then
          (fwd and s.expand_or_jump or s.jump)(d)
        elseif ng.jumpable(d) then
          (fwd and ng.jump_next or ng.jump_prev)()
        else
          fallback()
        end
      end
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
      }),
      formatting = {
        format = require("lspkind").cmp_format({ with_text = false }),
      },
      window = {
        completion = { border = require("configs.utils").border },
        documentation = { border = require("configs.utils").border },
      },
      experimental = {
        ghost_text = {
          hl_group = "LspCodeLens",
        },
      },
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path", keyword_length = 2 },
      }, {
        { name = "cmdline", keyword_length = 2 },
      }),
    })
  end,
}
