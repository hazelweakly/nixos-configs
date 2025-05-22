return {
  settings = {
    yaml = {
      format = { enable = false },
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
}
