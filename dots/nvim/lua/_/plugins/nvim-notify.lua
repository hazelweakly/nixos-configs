vim.notify = function(msg, ...)
  -- Hide unnecessary notifications because I use framework specific language servers
  local ignore = { "[lspconfig] Autostart", "method typescript/inlayHints" }
  for _, value in ipairs(ignore) do
    if string.find(msg, value, 1, true) then
      return
    end
  end
  require("notify")(msg, ...)
end
