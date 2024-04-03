{ self, inputs, ... }: self.lib.rake ./. // {
  rust-overlay = inputs.rust-overlay.overlays.default;
  inputs = _: _: { inherit inputs; };
  lix = inputs.lix-module.overlays.default;
}
