return {
  name = "nvim-treesitter",
  dir = os.getenv("TREESITTER_PLUGIN") .. "/pack/myNeovimPackages/start/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    highlight = { enable = true },
    auto_install = false,
    indent = { enable = true, disable = require("_.large_file").is_large_file },
    incremental_selection = {
      enable = true,
      disable = require("_.large_file").is_large_file,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<TAB>",
        node_decremental = "<S-TAB>",
      },
    },
  },
  config = function(_, opts)
    -- ugly hack to "add" zsh: https://github.com/nvim-treesitter/nvim-treesitter/issues/655
    local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang
    ---@diagnostic disable-next-line: duplicate-set-field
    require("nvim-treesitter.parsers").ft_to_lang = function(ft)
      if ft == "zsh" then
        return "bash"
      end
      return ft_to_lang(ft)
    end
    require("nvim-treesitter.configs").setup(opts)
  end,
}
