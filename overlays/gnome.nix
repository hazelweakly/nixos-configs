final: prev: {
  pop-shell-shortcuts = prev.rustPlatform.buildRustPackage rec {
    pname = "pop-shell-shortcuts";
    version = "2020-09-28";
    src = final.inputs.pop-os-shell-shortcuts;
    cargoSha256 = "sha256-kuaepwKsNHRH4SFLNrQhy1CTPR/HcpVuTyzuTPDaKQI=";
    nativeBuildInputs = [ prev.pkg-config ];
    buildInputs = [ prev.gtk3 prev.glib ];
  };

  gnomeExtensions = prev.gnomeExtensions // {
    pop-os = prev.stdenv.mkDerivation rec {
      pname = "gnome-shell-extension-pop-os-shell";
      version = "master";
      src = final.inputs.pop-os-shell;
      uuid = "pop-shell@system76.com";
      nativeBuildInputs = [
        prev.glib
        prev.nodePackages.typescript
        prev.gjs
        prev.wrapGAppsHook
        prev.gobject-introspection
      ];
      patches = [ ../fix-gjs.patch ];
      buildInputs = [ prev.gobject-introspection prev.gjs ];
      makeFlags = [
        "INSTALLBASE=$(out)/share/gnome-shell/extensions PLUGIN_BASE=$(out)/share/pop-shell/launcher SCRIPTS_BASE=$(out)/share/pop-shell/scripts"
      ];
      postInstall = ''
        chmod +x $out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js
        chmod +x $out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js

        mkdir -p $out/share/gnome-control-center/keybindings
        cp -r keybindings/*.xml $out/share/gnome-control-center/keybindings

        mkdir -p $out/share/gsettings-schemas/pop-shell-${version}/glib-2.0
        schemadir=${prev.glib.makeSchemaPath "$out" "${pname}-${version}"}
        mkdir -p $schemadir
        cp -r $out/share/gnome-shell/extensions/$uuid/schemas/* $schemadir
      '';
    };
    night-theme-switcher =
      prev.gnomeExtensions.night-theme-switcher.overrideAttrs (o: {
        version = "50";
        src = final.inputs.night-theme-switcher;
      });
  };
}
