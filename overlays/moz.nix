final: prev:
let
  mapAttrs = prev.stdenv.lib.mapAttrs;
  flip = prev.stdenv.lib.flip;
in
{
  latest = (prev.latest or { }) // {
    rustChannels = flip mapAttrs prev.latest.rustChannels (
      _: value:
        value // {
          rust = value.rust.override { extensions = [ "rust-src" ]; };
        }
    );
  };
}
