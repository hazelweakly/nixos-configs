for _, value in ipairs({ "Install", "Update", "Sync", "Clean", "Compile", "Status" }) do
  vim.api.nvim_add_user_command("Packer" .. value, function(tbl)
    require("plugins")
    local packer_pre_fn = require("configs.utils").packer_pre_fn
    if packer_pre_fn[value] then
      packer_pre_fn[value]()
    end
    if tbl.args ~= "" then
      require("packer")[value:lower()](tbl.args)
    else
      require("packer")[value:lower()]()
    end
  end, { nargs = "*", complete = require("packer").plugin_complete })
end
