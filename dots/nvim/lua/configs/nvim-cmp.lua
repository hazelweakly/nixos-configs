local cmp = require("cmp")

--- This tab key behaves pretty closely to how vscode does things.
-- It is used with a configuration that completely disables using
-- the enter key to confirm completion in any way.
---@param d "'forward'" | "'back'"
---@param m "'i'" | "'c'" | "'s'"
---@return none
local function tab(d, m)
  local fwd = d == "forward"
  return function(fallback)
    local l, ng = require("luasnip"), require("neogen")

    if m == "c" then
      if cmp.visible() then
        return (fwd and cmp.select_next_item or cmp.select_prev_item)()
      else
        return cmp.complete()
      end
    end

    if fwd and cmp.visible() then
      cmp.confirm({ select = true })
    elseif (fwd and l.expand_or_jumpable or l.jumpable)(fwd and 1 or -1) then
      (fwd and l.expand_or_jump or l.jump)(fwd and 1 or -1)
    elseif ng.jumpable(not fwd) then
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
    ["<CR>"] = cmp.config.disable,
    ["<Tab>"] = cmp.mapping({
      i = tab("forward", "i"),
      s = tab("forward", "s"),
      c = tab("forward", "c"),
    }),
    ["<S-Tab>"] = cmp.mapping({
      i = tab("back", "i"),
      s = tab("back", "s"),
      c = tab("back", "c"),
    }),
  },
  sources = cmp.config.sources({
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer", keyword_length = 3 },
    { name = "path", trigger_characters = { "/" } },
  }),
  formatting = {
    format = require("lspkind").cmp_format({ with_text = false }),
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

local sources = cmp.get_config().sources
local table_concat = function(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

cmp.setup.filetype({ "markdown", "tex" }, {
  sources = cmp.config.sources(table_concat(sources, {
    { name = "nuspell", keyword_length = 4, max_item_count = 3 },
    { name = "emoji" },
    { name = "latex_symbols" },
  })),
})

cmp.event:on("complete_done", function(_)
  require("lsp_signature").signature()
end)
