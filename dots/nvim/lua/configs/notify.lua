vim.notify = function(msg, ...)
  -- Hide unnecessary notifications because I use framework specific language servers
  if string.find(msg, "[lspconfig] Autostart", 1, true) then
    return
  end
  require("notify")(msg, ...)
end
