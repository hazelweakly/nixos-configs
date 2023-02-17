return {
  "echasnovski/mini.surround",
  keys = function(_, keys)
    local mappings = {
      { "sa", mode = { "n", "v" } },
      "sd",
      "sf",
      "sF",
      "sh",
      "sr",
      "sn",
    }
    return vim.list_extend(mappings, keys)
  end,
  opts = {},
  config = function(_, opts)
    require("mini.surround").setup(opts)
  end,
}
