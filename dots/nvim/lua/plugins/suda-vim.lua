return {
  "lambdalisue/suda.vim",
  cmd = "W",
  init = function()
    vim.g.suda_smart_edit = 1
    vim.cmd([[command! W :w suda://%]])
  end
}
