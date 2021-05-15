{ stdenv, fetchFromGitHub, rustPlatform, gtk3, glib, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "pop-shell-shortcuts";
  version = "2020-09-28";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell-shortcuts";
    rev = "a653635e0f4774a5f6983a790ebf2d44c72035e0";
    sha256 = "08ljyr0gjka6fs05v6gnz39x8y099cargpp0cbb2qb944s0gbg1z";
  };

  cargoSha256 = "0xw7z60xgzf8qr7c7rqmvv9p2xg4ya3379rbhmm5ka9jsj78cgiv";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 glib ];

  meta = with stdenv.lib; {
    description =
      "Shortcuts for the tiling window management extension for GNOME shell";
    homepage = "https://github.com/pop-os/shell-shortcuts";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maxeaubrey ];
    platforms = platforms.linux;
  };
}
