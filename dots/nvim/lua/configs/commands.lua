for _, value in ipairs({ "Install", "Update", "Sync", "Clean", "Compile", "Status" }) do
  vim.api.nvim_add_user_command("Packer" .. value, function()
    vim.cmd("packadd packer.nvim")
    require("plugins")[value:lower()]()
  end, {})
end
