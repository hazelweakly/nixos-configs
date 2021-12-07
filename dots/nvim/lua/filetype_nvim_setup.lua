require("filetype").setup({
  overrides = {
    extensions = {
      stack = "yaml",
      babelrc = "json",
      tex = "tex",
      just = "just",
      tf = "terraform",
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
    },
    complex = {
      ["docker-compose*.{yaml,yml}*"] = "yaml",
      ["ghost-*"] = "html",
      ["*/templates/*.yaml"] = "helm.yaml",
      ["*/templates/*.tpl"] = "helm.yaml",
    },
  },
})
