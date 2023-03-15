return function(opts)
  require("haskell-tools").setup({
    tools = { hover = { stylize_markdown = true } },
    hls = require("configs.utils").merge(opts, {
      settings = {
        haskell = {
          formattingProvider = "fourmolu",
          formatOnImportOn = true,
          completionSnippetOn = true,
          hlintOn = true,
          checkProject = false,
          maxCompletions = 10,
        },
      },
      cmd_env = { GHCRTS = "-M24G" },
      force_setup = true,
    }),
  })
end
