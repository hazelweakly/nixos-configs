-- This joins ``` man into ```man
-- cus lol that's why
local hover = function(_, result, ctx, config)
  if not (result and result.contents) then
    return vim.lsp.handlers.hover(_, result, ctx, config)
  end
  if type(result.contents) == "string" then
    local s = string.gsub(result.contents or "", "``` man", "```man")
    result.contents = s
    return vim.lsp.handlers.hover(_, result, ctx, config)
  else
    local s = string.gsub((result.contents or {}).value or "", "``` man", "```man")
    result.contents.value = s
    return vim.lsp.handlers.hover(_, result, ctx, config)
  end
end

return {
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(hover, { border = require("configs.utils").border }),
  },
}
