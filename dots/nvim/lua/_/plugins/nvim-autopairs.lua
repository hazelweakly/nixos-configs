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

-- Setup everything manually because nightly breakage
require("tabout").setup({
  act_as_shift_tab = false,
  tabkey = "",
  backwards_tabkey = "",
  completion = false,
})

-- Fix breakage with nightly neovim
local map = require("configs.utils").map
map("i", "<Tab>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-n>" or "<Plug>(TaboutMulti)"
end, { expr = true })
map("i", "<S-Tab>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-p>" or "<Plug>(TaboutBackMulti)<C-d>"
end, { expr = true })

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
