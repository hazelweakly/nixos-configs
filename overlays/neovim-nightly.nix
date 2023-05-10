final: prev: rec {
  # The override is so that neovim gets the right version of treesitter.
  # *That* is needed because I pin the "nixpkgs" from neovim to an old version
  # due to patch inconsistencies.
  #
  # NiX iS sUpErIoR (tm)
  neovim-unwrapped = neovim-nightly; # Needed so that neovim-remote picks up the right neovim
  neovim-nightly =
    # https://github.com/NixOS/nixpkgs/issues/229275
    let
      liblpeg = final.stdenv.mkDerivation {
        pname = "liblpeg";
        inherit (final.luajitPackages.lpeg) version meta src;

        buildInputs = [ final.luajit ];

        buildPhase = ''
          sed -i makefile -e "s/CC = gcc/CC = clang/"
          sed -i makefile -e "s/-bundle/-dynamiclib/"

          make macosx
        '';

        installPhase = ''
          mkdir -p $out/lib
          mv lpeg.so $out/lib/lpeg.dylib
        '';

        nativeBuildInputs = [ final.fixDarwinDylibNames ];
      };
    in
    (final.inputs.neovim-flake.packages.${prev.system}.neovim.override {
      tree-sitter = final.tree-sitter;
    }).overrideAttrs (o:
      if final.stdenv.isDarwin then {
        preConfigure = ''
          sed -i cmake.config/versiondef.h.in -e 's/@NVIM_VERSION_PRERELEASE@/-dev-${o.version}/'
        '';
        nativeBuildInputs = o.nativeBuildInputs ++ [
          liblpeg
          final.libiconv
        ];
      } else { });
  neovim-remote = prev.neovim-remote.overridePythonAttrs (o: { doCheck = false; });
}
