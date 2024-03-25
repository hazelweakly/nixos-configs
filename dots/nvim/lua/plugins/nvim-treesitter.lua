return {
  "nvim-treesitter/nvim-treesitter",
  name = "nvim-treesitter",
  init = function(plugin)
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,

  dir = os.getenv("TREESITTER_PLUGIN") .. "/pack/myNeovimPackages/start/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  keys = {
    { "<CR>", desc = "Init selection" },
    { "<TAB>", desc = "Increment selection", mode = "x" },
    { "<S-TAB>", desc = "Decrement selection", mode = "x" },
  },
  opts = {
    highlight = { enable = true },
    auto_install = false,
    -- ensure_installed = {},
    ignore_install = { "all" },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<TAB>",
        node_decremental = "<S-TAB>",
      },
    },
  },
  config = function(_, opts)
    vim.treesitter.language.register("bash", "zsh")

    require("nvim-treesitter.configs").setup(opts)
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "nvim_treesitter#foldexpr()"
    vim.o.foldenable = false
    vim.o.foldtext =
      [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g'). ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
    vim.o.fillchars = "fold: "

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.just = {
      install_info = {
        url = os.getenv("TREESITTER_PLUGIN")
          .. "/pack/myNeovimPackages/start/nvim-treesitter/nvim-treesitter-grammar-just",
        files = { "parser/just.so" },
      },
    }
  end,
}
