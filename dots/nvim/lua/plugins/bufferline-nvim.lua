return {
  "akinsho/bufferline.nvim",
  event = "User UltraLazy",
  opts = {
    options = {
      show_close_icon = false,
      show_buffer_close_icons = false,
      always_show_bufferline = false,
      diagnostics = "nvim_lsp",
      show_duplicate_prefix = true,
      diagnostics_indicator = function(_, _, diagnostics_dict)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " " or (e == "warning" and " " or "")
          s = s .. n .. sym
        end
        return s
      end,
      separator_style = { " ", " " },
    },
  },
}
