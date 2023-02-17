return {
  "rcarriga/nvim-notify",
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Delete all Notifications",
    },
  },
  opts = {
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
  init = function()
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
  end,
}
