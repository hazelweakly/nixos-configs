final: prev: {
  kitty = prev.kitty.overrideAttrs (o: {
    patches = o.patches ++ prev.lib.optionals prev.stdenv.isDarwin [
      (prev.writeText "kitty.patch" ''
        diff --git a/setup.py b/setup.py
        index 688e7703..82d281f8 100755
        --- a/setup.py
        +++ b/setup.py
        @@ -199,7 +199,7 @@ def get_python_flags(cflags: List[str]) -> List[str]:
                 ldlib = sysconfig.get_config_var('VERSION')
                 if ldlib:
                     libs += [f'-lpython{ldlib}{sys.abiflags}']
        -        libs += (sysconfig.get_config_var('LINKFORSHARED') or ${"''"}).split()
        +        libs += (sysconfig.get_config_var('LINKFORSHARED') or ${"''"}).replace('-Wl,-stack_size,1000000', ${"''"}).split()
             return libs
 
 
      '')
    ];
  });
}
