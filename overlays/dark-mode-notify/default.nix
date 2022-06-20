final: prev: {
  dark-mode-notify = prev.writeScriptBin "dark-mode-notify" (builtins.readFile ./dark-mode-notify.swift);
}
