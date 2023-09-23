return {
  "nvim-treesitter/nvim-treesitter",
  name = "nvim-treesitter",

  -- dir = os.getenv("TREESITTER_PLUGIN") .. "/pack/myNeovimPackages/start/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    { "<CR>", desc = "Init selection" },
    { "<TAB>", desc = "Increment selection", mode = "x" },
    { "<S-TAB>", desc = "Decrement selection", mode = "x" },
  },
  opts = {
    highlight = { enable = true },
    auto_install = false,
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
  end,
}
