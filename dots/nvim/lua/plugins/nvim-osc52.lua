return {
  "ojroques/nvim-osc52",
  opts = {},
  init = function()
    local function copy(lines, _)
      require("osc52").copy(table.concat(lines, "\n"))
    end

    vim.g.clipboard = {
      name = "osc52",
      copy = { ["+"] = copy, ["*"] = copy },
      paste = { ["+"] = { "wl-paste" }, ["*"] = { "wl-paste" } },
    }

    vim.api.nvim_create_autocmd("TextYankPost", {
      pattern = "*",
      callback = function()
        if vim.v.event.operator == "y" and vim.v.event.regname == "" then
          vim.fn.setreg("+", table.concat(vim.v.event.regcontents, "\n"))
        end
      end,
    })
  end,
}
