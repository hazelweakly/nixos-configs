{ self, inputs, ... }: self.lib.rake ./. // {
  rust-overlay = inputs.rust-overlay.overlay;
  inputs = _: _: { inherit inputs; };
}
