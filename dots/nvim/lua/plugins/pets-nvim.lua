return {
  "giusgad/pets.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "edluffy/hologram.nvim" },
  opts = { random = true },
  keys = {
    {
      "<leader>pn",
      function()
        local names = { "cutie", "whiskers", "felix", "fluffy", "angel", "gigi", "belle", "leo", "rocky", "binx" }
        local r = math.random(1, #names)
        return "<cmd>PetsNew " .. names[r] .. "<cr>"
      end,
      expr = true,
      remap = true,
    },
    { "<leader>pka", "<cmd>PetsKillAll<cr>" },
  },
}
