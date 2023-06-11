return {
  "lewis6991/gitsigns.nvim",
  event = "User UltraLazy",
  keys = { "gn", "gp" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "▔" },
      changedelete = { text = "▋" },
      untracked = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      map("n", "gn", gs.next_hunk, "Next Hunk")
      map("n", "gp", gs.prev_hunk, "Prev Hunk")
    end,
  },
}
