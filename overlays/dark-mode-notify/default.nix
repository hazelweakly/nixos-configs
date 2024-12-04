final: prev: {
  dark-mode-notify =
    let
      writeSwift = name: { swift ? "/usr"
                         , swiftcArgs ? [ ]
                         , strip ? false
                         }: prev.writers.makeBinWriter
        {
          compileScript = ''
            cp $contentPath tmp.swift
            export PATH="$PATH:${prev.swift.bintools}/bin"
            ${swift}/bin/swiftc ${prev.lib.escapeShellArgs swiftcArgs} tmp.swift
            mv tmp $out
          '';
          inherit strip;
        }
        name;

      writeSwiftBin = name: writeSwift "/bin/${name}";
    in

    writeSwiftBin "dark-mode-notify" { swift = prev.swift; } (builtins.readFile ./dark-mode-notify.swift);
}
