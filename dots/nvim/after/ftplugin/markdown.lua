vim.b.did_sandwich_markdown_ftplugin = 1

vim.b["sandwich_recipes"] = vim.fn["sandwich#get_recipes"]() or {}
vim.b["sandwich_recipes"] = vim.list_extend(vim.b["sandwich_recipes"], {
  {
    buns = { "```", "```" },
    input = { "`" },
    nesting = 0,
    motionwise = { "line" },
    action = { "add" },
    kind = { "add", "replace" },
  },
  { buns = "v:lua.Backtick()", input = { "`" }, nesting = 0, listexpr = 1, linewise = 1, action = { "delete" } },
})

function _G.Backtick()
  local n = 0
  while true do
    local nn = n + 1
    local pat = string.rep("`", nn)
    local s = vim.fn.searchpos([[\%(^\|[^`]\)\zs]] .. pat, "bcnW")
    local e = vim.fn.searchpos(pat .. [[\ze\%([^`]\|$\)]], "cnW")
    if s[1] == 0 or e[1] == 0 or n > 5 then
      return { "", "" }
    end
    local past_start = vim.fn.getline(s[1]):sub(s[2] + nn, s[2] + nn)
    local before_end = vim.fn.getline(e[1]):sub(e[2] - 1, e[2] - 1)
    if past_start ~= "`" and before_end ~= "`" then
      return { pat, pat }
    end
    n = n + 1
  end
end

require("configs.utils").ftplugin.undo({
  "unlet b:did_sandwich_markdown_ftplugin",
  [[if exists("sandwich#util#ftrevert") | call sandwich#util#ftrevert("markdown") | endif]],
})
