local is_root = vim.env.USER == "root"

vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]

vim.g.python_host_skip_check = 1

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
-- vim.opt.clipboard = "unnamedplus"
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
vim.opt.shortmess:append("caIA")
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

vim.g.markdown_fenced_languages = {
  "js=javascript",
  "ts=typescript",
  "tsx=typescriptreact",
}
local b64 = require("_.base64")

local function copy(lines, _)
  local data = b64.to_base64(table.concat(lines, "\n"))
  io.stderr:write("\027]52;c;" .. data .. "\027\\")
end

local function parse_line(file)
  local lines = {}
  local isEsc = false
  local curr = ""
  local fuck = 0

  repeat
    isEsc = curr == "\027"
    curr = file:read(1)
    lines[#lines + 1] = curr
    fuck = fuck + 1
  until isEsc and curr == "\\" or fuck >= 10000
  local line = table.concat(lines)
  local _, j = line:find("read:status=")
  local s = line:sub(j + 1, j + 4)
  s = s == "OK\27\\" and "OK" or s
  vim.pretty_print(lines)
  if s == "DATA" then
    line = line:sub(52, -3)
    line = b64.from_base64(line)
  else
    line = ""
  end

  return { line = line, status = s }
end

local function paste()
  local ttyHandle = io.popen([[tty < /proc/]] .. vim.loop.os_getpid() .. [[/fd/0]], "r")
  if ttyHandle == nil then
    return {}
  end
  local tty = ttyHandle:read("*l")
  ttyHandle:close()

  local ffi = require("ffi")

  --- The libc functions used by this process.
  ffi.cdef([[
      int open(const char* pathname, int flags);
      int close(int fd);
      int read(int fd, void* buf, size_t count);
 ]])
  local O_NONBLOCK = 2048
  local chunk_size = 4096
  local buffer = ffi.new("uint8_t[?]", chunk_size)
  local fd = ffi.C.open("/dev/fd/2", O_NONBLOCK)
  vim.pretty_print(fd)
  local nbytes = assert(ffi.C.read(fd, buffer, chunk_size))
  vim.pretty_print("ayoo, lmao", tty, nbytes, buffer)

  return {}
  -- local ttyFile = io.open(tty, "rb")
  -- if ttyFile == nil then
  --   return {}
  -- end
  --
  -- io.stderr:write("\027]5522;type=read;" .. b64.to_base64("text/plain") .. "\027\\")
  --
  -- local fuck_you = {}
  -- repeat
  --   local result = parse_line(ttyFile)
  --   if result.line ~= "" then
  --     for line in result.line:gmatch("([^\n]*)(\n?)") do
  --       fuck_you[#fuck_you + 1] = line
  --     end
  --   end
  -- until result.status == "DONE"
  -- ttyFile:close()
  -- -- table.remove(fuck_you, #fuck_you)
  -- vim.pretty_print("the fuck you table: ", fuck_you, #fuck_you)
  -- -- for _ = 1, 10, 1 do
  -- --   for i = 1, #fuck_you, 1 do
  -- --     fuck_you[#fuck_you + 1] = fuck_you[i]
  -- --   end
  -- -- end
  --
  -- return {
  --   fuck_you,
  --   "",
  -- }
  -- return {
  --   vim.fn.split(vim.fn.system([[base64 -d]], result.line), "\n"),
  --   vim.fn.getregtype(""),
  -- }
end

-- https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda

-- OSC
-- esc ] (standard. C0 variant)
-- 0x9D (non-standard. C1 variant)
-- \033] (octal C0 variant)
-- \x1B] (hex C0 variant)
-- \x9D (non-standard hex C1 variant)
-- \u009d (utf8 representation of \x9d (terminal dependent))
-- \U009d (completely different (terminal dependent))

-- ST
-- ESC \
-- 0x9C
-- \a
-- \033\

-- https://github.com/neovim/neovim/issues/12622#issuecomment-657110520
-- vim.g.clipboard = {
--   name = "osc52",
--   copy = { ["+"] = copy, ["*"] = copy },
--   paste = { ["+"] = { "wl-paste" }, ["*"] = { "wl-paste" } },
--
--   cache_enabled = 1,
-- }

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      vim.fn.setreg("+", table.concat(vim.v.event.regcontents, "\n"))
    end
  end,
})
