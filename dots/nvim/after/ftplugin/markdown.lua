---@diagnostic disable: missing-fields, param-type-mismatch
-- Surround markdown link title, using clipboard contents
require("nvim-surround").buffer_setup({
  surrounds = {
    ["l"] = {
      add = function()
        local clipboard = vim.fn.getreg("+"):gsub("\n", "")
        return {
          { "[" },
          { "](" .. clipboard .. ")" },
        }
      end,
      find = "%b[]%b()",
      delete = "^(%[)().-(%]%b())()$",
      change = {
        target = "^()()%b[]%((.-)()%)$",
        replacement = function()
          local clipboard = vim.fn.getreg("+"):gsub("\n", "")
          return {
            { "" },
            { clipboard },
          }
        end,
      },
    },
    ["q"] = {
      add = function()
        local clipboard = vim.fn.getreg("+"):gsub("\n", "")
        return {
          { "[" },
          { "](" .. clipboard .. ")" },
        }
      end,
      find = "%b[]%b()",
      delete = "^(%[)().-(%]%b())()$",
      change = {
        target = "^()()%b[]%((.-)()%)$",
        replacement = function()
          local clipboard = vim.fn.getreg("+"):gsub("\n", "")
          return {
            { "" },
            { clipboard },
          }
        end,
      },
    },
  },
})
