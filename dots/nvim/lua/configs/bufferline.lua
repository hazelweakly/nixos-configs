require("bufferline").setup({
  options = {
    show_close_icon = false,
    show_buffer_close_icons = false,
    always_show_bufferline = false,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = true,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " " or (e == "warning" and " " or "")
        s = s .. n .. sym
      end
      return s
    end,
    separator_style = { " ", " " },
  },
})
