return {
  "nvim-treesitter/nvim-treesitter",
  name = "nvim-treesitter",
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  init = function(plugin)
    vim.opt.runtimepath:prepend(os.getenv("TREESITTER_PARSERS"))
    require("lazy.core.loader").add_to_rtp(plugin)
  end,
  dir = os.getenv("TREESITTER_PLUGIN") .. "/pack/myNeovimPackages/start/nvim-treesitter",
  event = "LazyFile",
  keys = {
    { "<CR>", desc = "Init selection" },
    { "<TAB>", desc = "Increment selection", mode = "x" },
    { "<S-TAB>", desc = "Decrement selection", mode = "x" },
  },
  opts = {
    indent = { enable = true },
    auto_install = false,
    install_dir = os.getenv("TREESITTER_PLUGIN") .. "/pack/myNeovimPackages/start/nvim-treesitter-grammars",
    ensure_installed = {},
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
    vim.treesitter.language.register("terraform", { "terraform", "terraform-vars" })

    require("nvim-treesitter").setup(opts)
    local group = vim.api.nvim_create_augroup("MyNvimTreesitter", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "*",
      callback = function(event)
        local has, _ = pcall(vim.treesitter.start)
        if has then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo[0][0].foldenable = false
          vim.wo[0][0].foldtext =
            [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g'). ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
          vim.wo[0][0].fillchars = "fold: "
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
        end
      end,
    })
  end,
}
