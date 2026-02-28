-- Future: https://github.com/kylechui/nvim-surround/discussions/53#discussioncomment-10070567
return {
  "kylechui/nvim-surround",
  keys = {
    { "sa", mode = { "n", "v" } },
    "sd",
    "sf",
    "sF",
    "sr",
  },
  config = function(_, opts)
    vim.g.nvim_surround_no_normal_mappings = true
    require("nvim-surround").setup(opts)
    vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", {
      desc = "Add a surrounding pair around a motion (normal mode)",
    })
    vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)", {
      desc = "Delete a surrounding pair",
    })
    vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)", {
      desc = "Change a surrounding pair",
    })
    vim.keymap.set("n", "ssa", "<Plug>(nvim-surround-normal-cur)", {
      desc = "Add a surrounding pair around the current line (normal mode)",
    })
    vim.keymap.set("x", "sa", "<Plug>(nvim-surround-visual)", {
      desc = "Add a surrounding pair around a visual selection",
    })
  end,
  opts = {
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
}
