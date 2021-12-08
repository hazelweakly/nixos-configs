local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "go", "<cmd>pu _<CR>:'[-1<CR>")
map("n", "gO", "<cmd>pu! _<CR>:']+1<CR>")

-- Replace cursor under word. Pressing . will move to next match and repeat
map("n", "c*", "/<<C-R>=expand('<cword>')<CR>>C<CR>``cgn")
map("n", "c#", "?<<C-R>=expand('<cword>')<CR>>C<CR>``cgN")

-- Delete cursor under word. Pressing . will move to next match and repeat
map("n", "d*", "/<<C-R>=expand('<cword>')<CR>>C<CR>``dgn")
map("n", "d#", "?<<C-R>=expand('<cword>')<CR>>C<CR>``dgN")

map("n", "<C-j>", "<cmd>m .+1<CR>==")
map("n", "<C-k>", "<cmd>m .-2<CR>==")
map("i", "<C-j>", "<Esc>:m .+1<CR>==gi")
map("i", "<C-k>", "<Esc>:m .-2<CR>==gi")
map("x", "<C-j>", ":m '>+1<CR>gv=gv")
map("x", "<C-k>", ":m '<-2<CR>gv=gv")

map("x", "<", "<gv")
map("x", ">", ">gv")

vim.cmd([=[
    " Search for current selection when pressing * or # in visual mode
    xnoremap <silent> * :call VisualSearchCurrentSelection('f')<CR>
    xnoremap <silent> # :call VisualSearchCurrentSelection('b')<CR>
]=])
