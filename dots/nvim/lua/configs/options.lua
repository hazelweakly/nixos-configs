local is_root = vim.env.USER == "root"

vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]

vim.g.python_host_skip_check = 1

vim.g.netrw_dirhistmax = 0
vim.g.netrw_nogx = 1

vim.opt.title = true
vim.opt.pumblend = 30
vim.opt.winblend = 30
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.mouse = "a"
vim.opt.complete:append("k")
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.nrformats = "bin,hex,octal,alpha"
vim.opt.breakindent = true
vim.opt.backup = not is_root
vim.opt.writebackup = not is_root
vim.bo.undofile = not is_root
vim.bo.swapfile = not is_root
vim.opt.virtualedit = "block"
vim.opt.backupdir:remove(".")
vim.opt.list = true
vim.opt.listchars = "tab:▸ ,extends:❯,precedes:❮,trail:⌴"
vim.opt.showbreak = "↪  "
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 2
vim.opt.number = true
vim.opt.shortmess:append("cIA")
vim.opt.shortmess:remove("tToO")
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = false
vim.opt.wrap = false
vim.wo.foldenable = false
vim.opt.signcolumn = "yes"
vim.opt.syntax = "off"
vim.opt.cmdheight = 1

vim.opt.synmaxcol = 500
vim.opt.termguicolors = true
vim.opt.updatetime = 100
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fixendofline = false
vim.opt.pyx = 3
vim.opt.diffopt = "filler,internal,algorithm:histogram,indent-heuristic,hiddenoff"
vim.opt.spelllang = { "en_us" }
vim.opt_local.spelloptions:append("noplainbuffer")
vim.opt_local.spelloptions:append("camel")
vim.opt.shell = "/bin/sh"

vim.opt.foldnestmax = 3
vim.opt.foldminlines = 1

-- on OSX, gets overwritten by osc52 if on linux
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 0

vim.diagnostic.config({ update_in_insert = true })
vim.o.winborder = "rounded"
