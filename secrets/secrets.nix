with builtins;
let
  hazelKeys = fetchurl { url = "https://github.com/hazelweakly.keys"; sha256 = "0nz8fvz5i6f5bvsqj5ndk76snrbbgrfwvp5jd9gmsvqwrd7a2gvg"; };
  hazelKeyList = filter isString (split "\n" (readFile hazelKeys));
in
{ }
