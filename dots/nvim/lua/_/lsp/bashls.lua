-- This joins ``` man into ```man
-- cus lol that's why
local hover = function(_, result, ctx, config)
  if not (result and result.contents) then
    return vim.lsp.handlers.hover(_, result, ctx, config)
  end

  local s = ""
  if type(result.contents) == "string" then
    s = result.contents
  else
    s = (result.contents or {}).value
  end
  s = string.gsub(s or "", "``` man", "```man")

  if type(result.contents) == "string" then
    result.contents = s
  else
    result.contents.value = s
  end

  return vim.lsp.handlers.hover(_, result, ctx, config)
end

return {
  handlers = {
    ["textDocument/hover"] = hover,
  },
}
