-- Ignore unknown filetypes in checkhealth, they're false positives
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
    d2 = "d2",
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
    ["compose.*%.ya?ml"] = "yaml.docker-compose",
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    ["ghost-*"] = "html",
    [".*/templates/*%.tpl"] = "yaml.helm",
    [".*/templates/.*%.ya?ml"] = "yaml.helm",
  },
})
