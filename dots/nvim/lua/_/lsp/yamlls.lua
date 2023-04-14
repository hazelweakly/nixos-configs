-- This strips out the bullshit that yamlls sends us
-- who the fuck actually does text.intersperse("&emsp;") and expects those to
-- be zero width somehow. seriously?
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
  s = string.gsub(s or "", "&nbsp;", " ")
  s = string.gsub(s or "", "&emsp;", "")
  s = string.gsub(s, [[\\\n]], [[\n]])

  if type(result.contents) == "string" then
    result.contents = s
  else
    result.contents.value = s
  end

  return vim.lsp.handlers.hover(_, result, ctx, config)
end

return {
  settings = {
    yaml = {
      schemas = require("schemastore").yaml.schemas(),
    },
  },
  handlers = {
    ["textDocument/hover"] = hover,
  },
}
