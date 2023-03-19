return function(opts)
  local hack = vim.notify
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function() end -- lmao
  require("haskell-tools").start_or_attach({
    tools = {
      hover = { stylize_markdown = true },
      codeLens = { autoRefresh = false },
    },
    tags = { package_events = {} },
    hls = require("configs.utils").merge(opts, {
      settings = {
        haskell = {
          formattingProvider = "fourmolu",
          formatOnImportOn = true,
          completionSnippetOn = true,
          hlintOn = true,
          checkProject = true,
          maxCompletions = 10,
          plugin = { ["ghcide-type-lenses"] = { globalOn = true } },
        },
      },
      cmd_env = { GHCRTS = "-M24G" },
      force_setup = true,
    }),
  })
  vim.notify = hack
end
