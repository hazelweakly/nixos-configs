{ pkgs, lib, ... }: {
  system.activationScripts.applications.text = lib.mkForce "";
  system.activationScripts.postActivation.text = ''
    app_folder="$HOME/Applications/Nix"
    mkdir -p "$app_folder"
    IFS=$'\n'
    old_paths=($(mdfind kMDItemKind="Alias" -onlyin "$app_folder"))
    new_paths=($(find -L "$systemConfig/Applications" -maxdepth 1 -name '*.app'))
    unset IFS
    old_size="''${#old_paths[@]}"
    echo "removing $old_size aliased apps from $app_folder"
    for i in "''${!old_paths[@]}"; do
      rm -f "''${old_paths[$i]}"
    done
    new_size="''${#new_paths[@]}"
    echo "adding $new_size aliased apps into $app_folder"
    for i in "''${!new_paths[@]}"; do
      real_app=$(realpath "''${new_paths[$i]}")
      app_name=$(basename "''${new_paths[$i]}")
      rm -f "$app_folder/$app_name"
      ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_folder/$app_name"
    done
  '';
}
