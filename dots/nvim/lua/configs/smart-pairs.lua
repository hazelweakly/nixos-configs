-- require("pairs"):setup()
--
-- local cmp = require("cmp")
-- local kind = cmp.lsp.CompletionItemKind
-- cmp.event:on("confirm_done", function(event)
--   local item = event.entry:get_completion_item()
--   local parensDisabled = item.data and item.data.funcParensDisabled or false
--   if not parensDisabled and (item.kind == kind.Method or item.kind == kind.Function) then
--     require("pairs.bracket").type_left("(")
--   end
-- end)

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({ map_cr = true, check_ts = true })
npairs.add_rules({
  Rule(" ", " "):with_pair(function(opts)
    local pair = opts.line:sub(opts.col - 1, opts.col)
    return vim.tbl_contains({ "()", "[]", "{}" }, pair)
  end),
  Rule("( ", " )")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%)") ~= nil
    end)
    :use_key(")"),
  Rule("{ ", " }")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%}") ~= nil
    end)
    :use_key("}"),
  Rule("[ ", " ]")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%]") ~= nil
    end)
    :use_key("]"),
})

require("tabout").setup({
  act_as_shift_tab = true,
  completion = true,
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
