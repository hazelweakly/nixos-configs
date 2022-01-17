local env_dict = {
  FZF_PREVIEW_COMMAND = "bat --style=numbers,changes --color always {}",
  FZF_DEFAULT_OPTS = "--color=light --reverse ",
  FZF_DEFAULT_COMMAND = "fd -t f -L -H -E .git",
  BAT_THEME = "ansi",
}
for k, v in pairs(env_dict) do
  local ev = vim.env[k]
  vim.env[k] = (ev == nil or ev == "" and v) or ev
end
vim.o.shell = "bash"
vim.g.fzf_layout = { window = { width = 0.9, height = 0.9 } }
