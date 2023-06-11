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
    {
      "zbirenbaum/copilot-cmp",
      dependencies = "copilot.lua",
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup(opts)
        -- attach cmp source whenever copilot attaches
        -- fixes lazy-loading issues with the copilot cmp source
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.name == "copilot" then
              copilot_cmp._on_insert_enter({})
            end
          end,
        })
      end,
    },
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
        { name = "copilot" },
        { name = "nvim_lsp", max_item_count = 10 },
        -- place snips second otherwise ctrl+space doesn't give relevant completion
        { name = "luasnip", max_item_count = 5 },
        { name = "buffer", keyword_length = 3 },
        { name = "path", trigger_characters = { "/" } },
      }),
      formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol",
          max_width = 50,
          symbol_map = { Copilot = "" },
        }),
      },
      window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
      experimental = {
        ghost_text = {
          hl_group = "LspCodeLens",
        },
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          require("copilot_cmp.comparators").prioritize,

          -- Below is the default comparitor list and order for nvim-cmp
          cmp.config.compare.offset,
          -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
          cmp.config.compare.exact,
          cmp.config.compare.score,
          ---@diagnostic disable-next-line: assign-type-mismatch
          cmp.config.compare.recently_used,
          ---@diagnostic disable-next-line: assign-type-mismatch
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
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
        { name = "path", option = { keyword_length = 2 } },
      }, {
        { name = "cmdline", option = { keyword_length = 2 } },
      }),
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
