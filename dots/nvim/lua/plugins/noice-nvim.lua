return {
  "folke/noice.nvim",
  event = "User UltraLazy",
  keys = {
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll forward",
      mode = { "i", "n", "s" },
    },
    {
      "<c-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll backward",
      mode = { "i", "n", "s" },
    },
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
      hover = { silent = true },
    },
    presets = { command_palette = true, lsp_doc_border = true },
    routes = {
      {
        opts = { skip = true },
        filter = {
          any = {
            { event = "msg_show", find = "written" },
            { event = "msg_show", find = "Already at newest change" },
            { event = "msg_show", find = "No more valid diagnostics to move to" },
            { event = "msg_show", find = "change.*second.* ago" },
            { event = "msg_show", find = "line.*second.* ago" },
            { event = "msg_show", find = "fewer lines" },
            { event = "msg_show", find = "more lines" },
            { event = "msg_show", find = "lines yanked" },
            { event = "msg_show", find = "lines yanked" },
            { event = "msg_show", find = "lines >ed" },
            { error = true, find = "E486:" },
            { event = "lsp", kind = "progress", find = "code_action" },
          },
        },
      },
      { view = "notify", filter = { event = "msg_showmode", find = "recording" } },
      {
        view = "notify",
        filter = { error = true },
        opts = { title = "Error", replace = true, merge = true, level = "error" },
      },
      { view = "mini", filter = { event = "lsp", kind = "progress" }, opts = { replace = true, merge = true } },
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "nvim-treesitter",
  },
}
