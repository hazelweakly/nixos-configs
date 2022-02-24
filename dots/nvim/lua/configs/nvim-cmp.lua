local cmp = require("cmp")

-- This comment is needed because, somehow, autopairs is showing up before nvim-cmp.
---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
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
    ["<CR>"] = cmp.mapping({
      i = function(fallback)
        cmp.abort()
        fallback()
      end,
      s = function(fallback)
        cmp.abort()
        fallback()
      end,
      c = function(fallback)
        fallback()
      end,
    }),
    ["<Tab>"] = cmp.mapping({
      i = function(fallback)
        local luasnip = require("luasnip")
        local neogen = require("neogen")
        if cmp.visible() then
          cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif neogen.jumpable() then
          neogen.jump_next()
        else
          fallback()
        end
      end,
      s = function(fallback)
        local luasnip = require("luasnip")
        local neogen = require("neogen")
        if cmp.visible() then
          cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif neogen.jumpable() then
          neogen.jump_next()
        else
          fallback()
        end
      end,
      c = function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
    }),
    ["<S-Tab>"] = cmp.mapping({
      i = function(fallback)
        local luasnip = require("luasnip")
        local neogen = require("neogen")
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        elseif neogen.jumpable(true) then
          neogen.jump_prev()
        else
          fallback()
        end
      end,
      s = function(fallback)
        local luasnip = require("luasnip")
        local neogen = require("neogen")
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        elseif neogen.jumpable(true) then
          neogen.jump_prev()
        else
          fallback()
        end
      end,
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
    }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 3 },
    { name = "path", trigger_characters = { "/" } },
    { name = "nuspell", keyword_length = 4, max_item_count = 3 },
    { name = "emoji" },
    { name = "latex_symbols" },
  }),
  formatting = {
    format = require("lspkind").cmp_format({ with_text = false }),
  },
  completion = { completeopt = vim.o.completeopt },
  experimental = { ghost_text = true },
})
cmp.setup.cmdline("/", {
  sources = cmp.config.sources({ { name = "buffer" } }),
})
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path", keyword_length = 2 },
  }, {
    { name = "cmdline", keyword_length = 2 },
  }),
})

cmp.event:on("complete_done", function(_)
  require("lsp_signature").signature()
end)
