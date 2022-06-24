vim.filetype.add({
  extension = {
    stack = "yaml",
    babelrc = "json",
    tex = "tex",
    tf = "terraform",
    nomad = "hcl",
    cls = "tex", -- vimtex
    tik = "tex", -- vimtex
    nix = "nix",
    ts = "typescript",
  },
  filename = {
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
  pattern = {
    ["docker-compose*.{yaml,yml}*"] = "yaml",
    ["ghost-*"] = "html",
    ["*/templates/*.yaml"] = "helm.yaml",
    ["*/templates/*.tpl"] = "helm.yaml",
  },
})
