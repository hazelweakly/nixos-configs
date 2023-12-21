final: prev: {
  dark-mode-notify =
    let
      writeSwift = name: { swiftc ? "/usr"
                         , swiftcArgs ? [ ]
                         , strip ? false
                         }: prev.writers.makeBinWriter
        {
          compileScript = ''
            cp $contentPath tmp.swift
            ${swiftc}/bin/swiftc ${prev.lib.escapeShellArgs swiftcArgs} tmp.swift
            mv tmp $out
          '';
          inherit strip;
        }
        name;

      writeSwiftBin = name: writeSwift "/bin/${name}";
    in

    writeSwiftBin "dark-mode-notify" { } (builtins.readFile ./dark-mode-notify.swift);
}
