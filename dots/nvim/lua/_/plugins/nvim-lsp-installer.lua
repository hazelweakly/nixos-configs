local ss = require("nvim-lsp-installer.servers")

-- Some of the servers are preinstlaled with nix. If I wire them in here, I
-- don't need to split out my lsp registration setup and can handle everything
-- in a single location consistently.
for _, name in ipairs({ "rnix", "taplo", "zk" }) do
  local has, s = ss.get_server(name)
  if has then
    s._installer = function(_, callback, _)
      callback(true)
    end
  else
    require("configs.utils").log_err("server configs not available: " .. name, "[configs.lua]")
  end
end

local lsp_installer = require("nvim-lsp-installer")
local servers = {
  "ansiblels",
  "bashls",
  "clojure_lsp",
  "cssls",
  "dockerls",
  "emmet_ls",
  "eslint",
  "gopls",
  "hls",
  "html",
  "jsonls",
  "ltex",
  "pyright",
  "rnix",
  "rust_analyzer",
  "sumneko_lua",
  "tailwindcss",
  "taplo",
  "terraformls",
  "texlab",
  "tflint",
  "tsserver",
  "vimls",
  "yamlls",
  "zk",
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    require("configs.utils").log_info("Installing " .. name)
    server:install()
  end
end

lsp_installer.on_server_ready(function(server)
  local lsp = require("_.lsp")
  local merge = require("configs.utils").merge

  local has, s_opts = pcall(require, "_.lsp." .. server.name)
  if not has then
    s_opts = {}
  end

  local opts = merge(server:get_default_options(), lsp.default_opts())
  -- if opts.cmd_env ~= nil and opts.cmd_env.PATH ~= nil then
  --   opts.cmd_env.PATH = nil
  -- end
  if type(s_opts) == "function" then
    s_opts(server, opts)
  else
    server:setup_lsp(merge(opts, s_opts))
  end

  if not (opts.autostart == false) then
    server:attach_buffers()
  end
end)

vim.diagnostic.config({
  severity_sort = true,
  float = { border = require("configs.utils").border },
  virtual_text = false,
  update_in_insert = false,
  signs = true,
  underline = false,
})

for type, icon in pairs({ Error = " ", Warn = " ", Hint = " ", Info = " " }) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- This is here because this file is included and ran exactly once and is a stateful module.
vim.api.nvim_create_augroup("DirenvRestartServer", {})
vim.api.nvim_create_autocmd("User", {
  group = "DirenvRestartServer",
  pattern = "DirenvLoaded",
  callback = function()
    require("_.lsp").start_or_restart()
  end,
})
