-- TODO: Look at https://github.com/msvechla/yaml-companion.nvim/tree/kubernetes_crd_detection

-- This strips out the bullshit that yamlls sends us
-- who the fuck actually does text.intersperse("&emsp;") and expects those to
-- be zero width somehow. seriously?
local hover = function(_, result, ctx, config)
  if not (result and result.contents) then
    return vim.lsp.handlers.hover(_, result, ctx, config)
  end

  local s = ""
  if type(result.contents) == "string" then
    s = result.contents
  else
    s = (result.contents or {}).value
  end
  s = string.gsub(s or "", "&nbsp;", " ")
  s = string.gsub(s or "", "&emsp;", "")
  s = string.gsub(s, [[\\\n]], [[\n]])

  if type(result.contents) == "string" then
    result.contents = s
  else
    result.contents.value = s
  end

  return vim.lsp.handlers.hover(_, result, ctx, config)
end

local cfg = require("yaml-companion").setup({
  -- schemas available in Telescope picker
  schemas = {
    -- not loaded automatically, manually select with
    -- :Telescope yaml_schema
    {
      name = "Argo CD Application",
      uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
    },
    {
      name = "SealedSecret",
      uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
    },
  },
  lspconfig = {
    settings = {
      yaml = {
        schemaStore = { enable = false, url = "" },
        schemas = require("configs.utils").merge(require("schemastore").yaml.schemas(), {
          -- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/_definitions.json"] = "*.yaml",
          -- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/all.json"] = "/*.k8s.yaml",
          -- ["https://raw.githubusercontent.com/argoproj/argo-schema-generator/main/schema/argo_all_k8s_kustomize_schema.json"] = "**/argocd/**/*.{yml,yaml}", -- broken rn because of a missing dependency on k8s Time somehow?
        }),
      },
    },
    handlers = {
      ["textDocument/hover"] = hover,
    },
  },
})
-- vim.print(cfg)

return cfg
