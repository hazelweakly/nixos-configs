return {
  name = "nvim-treesitter",
  dir = os.getenv("TREESITTER_PLUGIN") .. "/pack/myNeovimPackages/start/nvim-treesitter",
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
    local parsers = require("nvim-treesitter.parsers")
    -- ugly hack to "add" zsh: https://github.com/nvim-treesitter/nvim-treesitter/issues/655
    local ft_to_lang = parsers.ft_to_lang
    ---@diagnostic disable-next-line: duplicate-set-field
    parsers.ft_to_lang = function(ft)
      if ft == "zsh" then
        return "bash"
      end
      return ft_to_lang(ft)
    end
    local parser_config = parsers.get_parser_configs()
    parser_config.dhall = {
      install_info = {
        url = "https://github.com/jbellerb/tree-sitter-dhall",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
      maintainers = { "@jbellerb" },
    }
    require("nvim-treesitter.configs").setup(opts)
  end,
}
