local is_root = vim.env.USER == "root"

vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]

vim.g.python_host_skip_check = 1
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.g.netrw_dirhistmax = 0
vim.g.netrw_nogx = 1

vim.opt.title = true
vim.opt.pumblend = 30
vim.opt.winblend = 30
vim.opt.grepprg = "rg --engine auto --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.mouse = "a"
vim.opt.complete:append("k")
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.nrformats = "bin,hex,octal,alpha"
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.backup = not is_root
vim.opt.writebackup = not is_root
vim.bo.undofile = not is_root
vim.bo.swapfile = not is_root
vim.opt.lazyredraw = true
vim.opt.virtualedit = "block"
vim.opt.backupdir:remove(".")
vim.opt.list = true
vim.opt.listchars = "tab:▸ ,extends:❯,precedes:❮,trail:⌴"
vim.opt.showbreak = "↪  "
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 2
vim.opt.number = true
vim.opt.shortmess:append("caIA")
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = false
vim.opt.wrap = false
vim.wo.foldenable = false
vim.opt.signcolumn = "yes"
vim.opt.syntax = "off"

vim.g.cursorhold_updatetime = 100
vim.opt.synmaxcol = 500
vim.opt.termguicolors = true
vim.opt.updatetime = 4001
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fixendofline = false
vim.opt.pyx = 3
vim.opt.diffopt = "filler,internal,algorithm:histogram,indent-heuristic,hiddenoff"
vim.opt.spelllang = { "en_us" }
vim.opt.shell = "/bin/sh"

-- Set filetypes that should be ignored in other plugins
vim.g.ignored_buffer_types = {
  "Trouble",
  "help",
  "nofile",
  "packer",
  "quickfix",
  "terminal",
}

vim.g.ignored_file_types = {
  "TelescopePrompt",
  "TelescopeResults",
  "checkhealth",
  "gitcommit",
  "gitrebase",
  "glowpreview",
  "help",
  "minimap",
  "packer",
  "vim",
}
