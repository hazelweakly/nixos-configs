final: prev:
let
  mapAttrs = prev.lib.mapAttrs;
  flip = prev.lib.flip;
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
