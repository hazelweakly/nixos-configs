---@private
local function getline(bufnr, lnum)
  return vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
end

vim.filetype.add({
  extension = {
    stack = "yaml",
    babelrc = "json",
    tex = "tex",
    tf = "terraform",
    cls = "tex", -- vimtex
    tik = "tex", -- vimtex
    nix = "nix",
    ts = function(_, bufnr)
      if getline(bufnr, 1):find("<%?xml") then
        return "xml"
      else
        return "typescript"
      end
    end,
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
