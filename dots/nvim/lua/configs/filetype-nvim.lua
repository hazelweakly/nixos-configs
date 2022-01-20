require("filetype").setup({
  overrides = {
    extensions = {
      stack = "yaml",
      babelrc = "json",
      tex = "tex",
      just = "just",
      tf = "terraform",
      cls = "tex", -- vimtex
      tik = "tex", -- vimtex
    },
    function_extensions = {
      tex = function()
        -- don't set filetype. cuz reasons
        -- https://github.com/lervag/vimtex/blob/c72d34bfca5972c36bb72c39098c62ea213d73ae/ftdetect/tex.vim#L12,L14
        vim.g.tex_flavor = "latex"
      end,
    },
    literal = {
      httpd = "apache",
      Justfile = "just",
      justfile = "just",
      [".Justfile"] = "just",
      [".justfile"] = "just",
      [".envrc"] = "direnv",
      [".direnvrc"] = "direnv",
      ["direnvrc"] = "direnv",
      ["flake.lock"] = "json",
    },
    complex = {
      ["docker-compose*.{yaml,yml}*"] = "yaml",
      ["ghost-*"] = "html",
      ["*/templates/*.yaml"] = "helm.yaml",
      ["*/templates/*.tpl"] = "helm.yaml",
    },
  },
})
