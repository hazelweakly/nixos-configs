require("mason-tool-installer").setup({
  ensure_installed = {
    "json-to-struct",
    "chrome-debug-adapter",
    "bash-debug-adapter",
    "node-debug2-adapter",
    "debugpy",
    "delve",
    "djlint",
  },
  auto_update = true,
})
