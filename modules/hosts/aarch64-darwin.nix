{ self, inputs, ... }@args: self.lib.mkDarwinSystem (args // {
  system = "aarch64-darwin";
})
