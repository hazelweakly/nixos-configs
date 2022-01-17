local luasnip = require("luasnip")
luasnip.config.setup({
  updateevents = "TextChanged,TextChangedI",
  region_check_events = "CursorMoved,CursorHold",
  delete_check_events = "TextChanged",
  enable_autosnippets = true,
  history = true,
})
require("luasnip.loaders.from_vscode").lazy_load()
