return {
  "machakann/vim-sandwich",
  enabled = false,
  config = function()
    vim.g["sandwich#recipes"] = vim.deepcopy(vim.g["sandwich#default_recipes"])
    vim.g.textobj_sandwich_no_default_key_mappings = 1
  end,
}
