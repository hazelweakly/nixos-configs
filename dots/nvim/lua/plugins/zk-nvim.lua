return {
  "mickael-menu/zk-nvim",
  opts = {
    picker = "telescope",
  },
  config = function(_, opts)
    require("zk").setup(opts)
  end,
}
