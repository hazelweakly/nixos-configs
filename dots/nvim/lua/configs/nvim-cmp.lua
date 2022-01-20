local luasnip = require("luasnip")
local cmp = require("cmp")
local doSig = function(_)
  if _LSP_SIG_CFG == nil then
    return false
  end
  local clients = {}
  vim.lsp.for_each_buffer_client(0, function(client, _, _)
    table.insert(clients, client)
  end)
  local cap, _, _, _ = require("lsp_signature.helper").check_lsp_cap(clients, "")
  if cap then
    vim.lsp.buf.signature_help()
  end
  return cap
end

-- This comment is needed because, somehow, autopairs is showing up before nvim-cmp.
---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
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
    ["<C-Space>"] = cmp.mapping.complete(),
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
        if cmp.visible() then
          cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      s = function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      c = function(fallback)
        fallback()
      end,
    }),
    ["<S-Tab>"] = cmp.mapping({
      i = function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      s = function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      c = function(fallback)
        fallback()
      end,
    }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 5, max_item_count = 5 },
    { name = "path", trigger_characters = { "/" } },
    { name = "nuspell", keyword_length = 5, max_item_count = 3 },
    { name = "emoji" },
    { name = "latex_symbols" },
  }),
  formatting = {
    format = require("lspkind").cmp_format({
      with_text = false,
    }),
  },
  completion = { completeopt = vim.o.completeopt },
  experimental = {
    ghost_text = true,
    native_menu = false,
  },
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

cmp.event:on("complete_done", doSig)
