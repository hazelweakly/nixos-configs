for _, value in ipairs({ "Install", "Update", "Sync", "Clean", "Compile", "Status" }) do
  vim.api.nvim_add_user_command("Packer" .. value, function(tbl)
    if tbl.args ~= "" then
      require("plugins")[value:lower()](tbl.args)
    else
      require("plugins")[value:lower()]()
    end
  end, { nargs = "*", complete = require("packer").plugin_complete })
end
