local cmp = require("cmp")

--- This tab key behaves pretty closely to how vscode does things.
-- It is used with a configuration that completely disables using
-- the enter key to confirm completion in any way.
---@param d 1 | -1
---@param m "'i'" | "'c'" | "'s'"
---@return none
local function tab(d, m)
  local fwd = d == 1
  return function(fallback)
    local s, ng = require("snippy"), require("neogen")

    if m == "c" then
      return cmp.visible() and (fwd and cmp.select_next_item or cmp.select_prev_item)() or cmp.complete()
    end

    if fwd and cmp.visible() then
      cmp.confirm({ select = true })
    elseif (fwd and s.can_expand_or_advance or s.can_jump)(d) then
      (fwd and s.expand_or_advance or s.previous)()
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
      require("snippy").expand_snippet(args.body)
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
    { name = "snippy", max_item_count = 5 },
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

local table_concat = function(t1, t2)
  local t0 = {}
  for _, v in ipairs(t1) do
    table.insert(t0, v)
  end
  for _, v in ipairs(t2) do
    table.insert(t0, v)
  end
  return t0
end

---@diagnostic disable-next-line: undefined-field
cmp.setup.filetype({ "markdown", "tex" }, {
  sources = cmp.config.sources(table_concat(cmp.get_config().sources, {
    { name = "nuspell", keyword_length = 4, max_item_count = 3 },
    { name = "emoji", option = { insert = true } },
    { name = "latex_symbols" },
  })),
})

cmp.event:on("complete_done", function(_)
  require("lsp_signature").signature()
end)
