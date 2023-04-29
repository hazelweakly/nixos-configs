final: prev: {
  xp-pen-deco-01-v2-driver = prev.xp-pen-deco-01-v2-driver.overrideAttrs (o: {
    src = prev.fetchzip {
      url = "https://www.xp-pen.com/download/file/id/1936/pid/440/ext/gz.html#.tar.gz";
      name = "xp-pen-deco-01-v2-driver-${o.version}.tar.gz";
      sha256 = "sha256-CV4ZaGCFFcfy2J0O8leYgcyzFVwJQFQJsShOv9B7jfI=";
    };

    nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ prev.makeShellWrapper ];
  });
}
