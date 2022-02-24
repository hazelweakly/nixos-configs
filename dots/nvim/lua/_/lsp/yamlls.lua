local schemas = require("schemastore").json.schemas({
  ignore = { ".build.yml", "Hammerkit YAML Schema" },
})
local yaml_schemas = {}
for _, value in ipairs(schemas) do
  yaml_schemas[value.url] = value.fileMatch
end
return {
  settings = {
    yaml = {
      schemas = yaml_schemas,
    },
  },
}
