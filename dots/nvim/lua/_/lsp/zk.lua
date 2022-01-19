return {
  on_attach = function(client, bufnr)
    require("_.lsp").on_attach(client, bufnr)
    if require("zk.util").notebook_root(vim.fn.expand("#" .. bufnr .. ":p")) == nil then
      return
    end
    require("zk").setup({ picker = "telescope", auto_attach = { enabled = false } })

    local buf_map = require("configs.utils").buf_map

    buf_map(bufnr, "n", "<leader>zn", function()
      return vim.ui.input({ prompt = "Title: " }, function(input)
        if input ~= nil then
          return require("zk").new({ title = input })
        end
      end)
    end)

    buf_map(bufnr, "n", "<leader>zz", require("zk").edit)
    buf_map(bufnr, "n", "<leader>zt", require("zk.commands").get("ZkTags"))

    buf_map(bufnr, "n", "<leader>zf", function()
      return vim.ui.input({ prompt = "Search: " }, function(input)
        if input ~= nil then
          return require("zk").edit({}, { telescope = { default_text = input } })
        end
      end)
    end)

    -- dum
    buf_map(bufnr, "v", "<leader>zf", ":'<,'>ZkMatch<CR>")
  end,
  root_dir = require("zk.util").notebook_root,
}
