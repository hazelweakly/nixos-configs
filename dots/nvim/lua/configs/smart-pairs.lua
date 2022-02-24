require("pairs"):setup()

local cmp = require("cmp")
local kind = cmp.lsp.CompletionItemKind
cmp.event:on("confirm_done", function(event)
  local item = event.entry:get_completion_item()
  local parensDisabled = item.data and item.data.funcParensDisabled or false
  if not parensDisabled and (item.kind == kind.Method or item.kind == kind.Function) then
    require("pairs.bracket").type_left("(")
  end
end)
