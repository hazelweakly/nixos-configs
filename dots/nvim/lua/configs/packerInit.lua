local present, packer = pcall(require, "packer")
if not present then
  vim.cmd("packadd packer.nvim")
  present, packer = pcall(require, "packer")
end

local utils = require("configs.utils")
local first_install = false

if not present then
  local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

  utils.log_info("Cloning packer..")
  vim.fn.delete(packer_path, "rf")
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    "--depth",
    "1",
    packer_path,
  })

  vim.cmd("packadd packer.nvim")
  present, packer = pcall(require, "packer")

  if present then
    utils.log_info("Packer cloned successfully.")
    first_install = true
  else
    error("Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer)
  end
end

packer.init({
  git = {
    clone_timeout = 600,
    subcommands = {
      fetch = "fetch --no-tags --no-recurse-submodules --update-shallow --progress",
    },
  },
  max_jobs = 30,
  display = {
    open_fn = function()
      return require("packer.util").float({ border = utils.border })
    end,
    prompt_border = utils.border,
  },
})

return { packer = packer, first_install = first_install }