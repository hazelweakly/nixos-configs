-- https://gabrielpoca.com/2019-11-13-a-bit-more-lua-in-your-vim/
function NavigationFloatingWin()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_var(buf, '&signcolumn', 'no')

    local win_height = height
    local win_width = width

    if (width > 150) then
        win_width = math.ceil(width * 0.9)
    end

    if (height > 35) then
        win_height = math.min(math.ceil(height * 3 / 4), 40)
    end

    local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = math.ceil((height - win_height) / 2),
        col = math.ceil((width - win_width) / 2)
    }

    local win = vim.api.nvim_open_win(buf, true, opts)
end
