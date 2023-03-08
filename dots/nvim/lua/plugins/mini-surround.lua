return {
  "kylechui/nvim-surround",
  keys = function(_, keys)
    local mappings = {
      { "sa", mode = { "n", "v" } },
      "sd",
      "sf",
      "sF",
      "sr",
    }
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    keymaps = { normal = "sa", normal_cur = "ssa", delete = "sd", change = "sr", visual = "sa" },
    surrounds = {
      ["F"] = {
        find = function()
          return require("nvim-surround.config").get_selection({ motion = "af" })
        end,
        delete = function()
          local ft = vim.bo.filetype
          local patt
          if ft == "lua" then
            patt = "^(.-function.-%b())().*(end)()$"
          else
            vim.notify("No function-surround defined for " .. ft)
            patt = "()()()()"
          end
          return require("nvim-surround.config").get_selections({
            char = "F",
            pattern = patt,
          })
        end,
      },
    },
  },
  config = function(_, opts)
    require("nvim-surround").setup(opts)
  end,
}
