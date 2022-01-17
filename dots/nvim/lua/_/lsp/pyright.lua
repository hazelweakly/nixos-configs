-- This strips out &nbsp; and some ending escaped backslashes out of hover
-- strings because the pyright LSP is... odd with how it creates hover strings.
local hover = function(_, result, ctx, config)
  if not (result and result.contents) then
    return vim.lsp.handlers.hover(_, result, ctx, config)
  end
  if type(result.contents) == "string" then
    local s = string.gsub(result.contents or "", "&nbsp;", " ")
    s = string.gsub(s, [[\\\n]], [[\n]])
    result.contents = s
    return vim.lsp.handlers.hover(_, result, ctx, config)
  else
    local s = string.gsub((result.contents or {}).value or "", "&nbsp;", " ")
    s = string.gsub(s, "\\\n", "\n")
    result.contents.value = s
    return vim.lsp.handlers.hover(_, result, ctx, config)
  end
end

return {
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(hover, { border = require("configs.utils").border }),
  },
}

