return function(server, opts)
  local on_attach = function(client, bufnr)
    opts.on_attach(client, bufnr)
    if require("zk.util").notebook_root(vim.fn.expand("#" .. bufnr .. ":p")) == nil then
      return
    end

    local buf_map = require("configs.utils").buf_map

    buf_map(bufnr, "n", "<leader>zn", function()
      return vim.ui.input({ prompt = "Title: " }, function(input)
        if input ~= nil then
          return require("zk").new({ title = input })
        end
      end)
    end)

    buf_map(bufnr, "n", "<leader>zz", function()
      return require("zk").edit({}, {})
    end)
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
  end

  local merge = require("configs.utils").merge
  local o = merge({
    lsp = { config = merge(opts, { on_attach = on_attach, auto_attach = false }) },
  }, { picker = "telescope" })

  if o.lsp.config.cmd_env ~= nil and o.lsp.config.cmd_env.PATH ~= nil then
    o.lsp.config.cmd_env.PATH = nil
  end
  require("zk").setup(o)
  local oo = require("zk.config").options.lsp.config
  oo.auto_attach = true
  server:setup_lsp(oo)
end
