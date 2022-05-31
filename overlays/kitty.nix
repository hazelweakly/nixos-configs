final: prev: with prev; {
#  kitty = (let src = fetchgit {
#      url = "https://github.com/leungbk/nixpkgs";
#      sparseCheckout = ''
#        pkgs/applications/terminal-emulators/kitty
#      '';
#      rev = "f3c611217c8973317b671c95274bcb5e86de0527";
#      sha256 = "sha256-6a3FntHp8VNTe4ZJEZoOM0chHd40jUA7gjEafZimD1s=";
#    };
#    in callPackage "${src}/pkgs/applications/terminal-emulators/kitty" {
#      inherit (darwin.apple_sdk.frameworks) Cocoa CoreGraphics Foundation IOKit Kernel OpenGL;
#    });
}
