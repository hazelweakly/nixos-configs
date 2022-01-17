-- some of the servers are preinstlaled with nix and not available in "nvim-lsp-installer"
-- If I wire them in here, I don't need to split out my lsp registration setup
-- and can handle everything in a single location consistently.
-- (except for zk which is special because of the zk-nvim plugin...)
local mkServer = function(name)
  local svr = require("nvim-lsp-installer.server")
  return svr.Server:new({
    name = name,
    root_dir = svr.get_server_root_path(name),
    ---@diagnostic disable-next-line: unused-local
    installer = function(server, callback, context)
      callback(true)
    end,
    default_options = require("lspconfig")[name].document_config.default_config,
  })
end

require("nvim-lsp-installer.servers").register(mkServer("rnix"))
require("nvim-lsp-installer.servers").register(mkServer("taplo"))

local lsp_installer = require("nvim-lsp-installer")
local servers = {
  "ansiblels",
  "bashls",
  "clojure_lsp",
  "cssls",
  "dockerls",
  "emmet_ls",
  "eslint",
  "hls",
  "html",
  "jsonls",
  "pyright",
  "rnix",
  "sumneko_lua",
  "tailwindcss",
  "taplo",
  "terraformls",
  "texlab",
  "tflint",
  "tsserver",
  "vimls",
  "yamlls",
}

local utils = require("configs.utils")
for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found then
    if not server:is_installed() then
      utils.log_info("Installing " .. name)
      server:install()
    end
  end
end

lsp_installer.on_server_ready(function(server)
  local lsp = require("_.lsp")
  server:setup(utils.merge(lsp.default_opts(), lsp.servers[server.name] or {}))
end)

vim.diagnostic.config({
  severity_sort = true,
  float = { border = utils.border },
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
