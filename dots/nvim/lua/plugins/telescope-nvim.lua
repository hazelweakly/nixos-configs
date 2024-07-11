return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    {
      "<leader><space>",
      function()
        return require("telescope.builtin").live_grep()
      end,
    },
    {
      "<leader>f",
      function()
        return require("telescope.builtin").find_files()
      end,
    },
    {
      "<leader>b",
      function()
        return require("telescope.builtin").buffers()
      end,
    },
    {
      "<leader>y",
      function()
        return require("yaml-companion").open_ui_select()
      end,
    },
  },
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      lazy = true,
      build = "make",
    },
    {
      "argogl/yaml-companion.nvim",
      lazy = true,
    },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
          "--iglob",
          "!.git",
          "--hidden",
        },
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
            ["<esc>"] = require("telescope.actions").close,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", "/.git/" },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("yaml_schema")
  end,
}
