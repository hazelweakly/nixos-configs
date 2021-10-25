if ! [[ -r "${XDG_DATA_HOME}/theme" ]]; then
  printf 'light' > "${XDG_DATA_HOME}/theme"
fi
export __sys_theme="$(<${XDG_DATA_HOME}/theme)"
