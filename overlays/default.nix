{ self, inputs, ... }: self.lib.rake ./. // {
  rust-overlay = inputs.rust-overlay.overlays.default;
  inputs = _: _: { inherit inputs; };
} // (if ("lix-module" ? inputs) then {
  lix = inputs.lix-module.overlays.default;
} else { })
