local register = require("nvim-lsp-installer.servers").register
local svr = require("nvim-lsp-installer.server")

-- Some of the servers are preinstlaled with nix. If I wire them in here, I
-- don't need to split out my lsp registration setup and can handle everything
-- in a single location consistently.
for _, name in ipairs({ "rnix", "taplo", "zk" }) do
  register(svr.Server:new({
    name = name,
    root_dir = svr.get_server_root_path(name),
    installer = function(_, callback, _)
      callback(true)
    end,
    default_options = require("lspconfig")[name].document_config.default_config,
  }))
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
  "hls",
  "html",
  "jsonls",
  "ltex",
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
  "zk",
}

local utils = require("configs.utils")
for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    utils.log_info("Installing " .. name)
    server:install()
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

for type, icon in pairs({ Error = " ", Warn = " ", Hint = " ", Info = " " }) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
